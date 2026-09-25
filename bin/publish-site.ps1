[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [string]$Message = "Update personal website",

    [string]$Branch = "main",

    [switch]$SkipValidation
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path

function Invoke-Git {
    param(
        [Parameter(Mandatory = $true)]
        [string[]]$GitArgs,

        [string]$UserName,

        [string]$UserEmail
    )

    $gitOptions = @("-c", "safe.directory=$repoRoot")
    if ($UserName -and $UserEmail) {
        $gitOptions += @("-c", "user.name=$UserName", "-c", "user.email=$UserEmail")
    }

    & git @gitOptions "-C" $repoRoot @GitArgs
    if ($LASTEXITCODE -ne 0) {
        throw "Git command failed: git $($GitArgs -join ' ')"
    }
}

function Test-ProjectFrontMatter {
    $projectFiles = @(Get-ChildItem -LiteralPath (Join-Path $repoRoot "_projects") -Filter "*.md" -File)
    if ($projectFiles.Count -eq 0) {
        throw "No project files were found in _projects."
    }

    $importanceValues = @{}
    foreach ($file in $projectFiles) {
        $content = Get-Content -LiteralPath $file.FullName -Raw
        $frontMatterMatch = [regex]::Match($content, "(?s)^---\r?\n(.*?)\r?\n---")
        if (-not $frontMatterMatch.Success) {
            throw "Missing front matter: $($file.Name)"
        }

        $frontMatter = $frontMatterMatch.Groups[1].Value
        foreach ($field in @("layout", "title", "description", "importance")) {
            if ($frontMatter -notmatch "(?m)^$field\s*:\s*\S") {
                throw "Missing '$field' in front matter: $($file.Name)"
            }
        }

        $importanceMatch = [regex]::Match($frontMatter, "(?m)^importance\s*:\s*(\d+)\s*$")
        if (-not $importanceMatch.Success) {
            throw "Importance must be an integer: $($file.Name)"
        }

        $importance = [int]$importanceMatch.Groups[1].Value
        if ($importanceValues.ContainsKey($importance)) {
            throw "Duplicate project importance '$importance': $($file.Name) and $($importanceValues[$importance])"
        }
        $importanceValues[$importance] = $file.Name
    }

    $projectsPage = Get-Content -LiteralPath (Join-Path $repoRoot "_pages\projects.md") -Raw
    if ($projectsPage -notmatch "site\.projects" -or $projectsPage -notmatch "projects\.liquid") {
        throw "_pages/projects.md does not render the projects collection."
    }
}

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw "Git is not available on PATH."
}

if ([string]::IsNullOrWhiteSpace($Message)) {
    throw "Commit message cannot be empty."
}

$currentBranch = (Invoke-Git @("branch", "--show-current") | Out-String).Trim()
if ($currentBranch -ne $Branch) {
    throw "Expected branch '$Branch', but the repository is on '$currentBranch'."
}

$commitAuthorName = (Invoke-Git @("show", "-s", "--format=%an", "HEAD") | Out-String).Trim()
$commitAuthorEmail = (Invoke-Git @("show", "-s", "--format=%ae", "HEAD") | Out-String).Trim()
if ([string]::IsNullOrWhiteSpace($commitAuthorName) -or [string]::IsNullOrWhiteSpace($commitAuthorEmail)) {
    throw "Could not determine a commit author from the repository history."
}

if (-not $SkipValidation) {
    Write-Host "Checking whitespace..."
    Invoke-Git @("diff", "--check")

    $bashPath = $null
    $bashCommand = Get-Command bash.exe -ErrorAction SilentlyContinue
    if ($bashCommand) {
        $bashPath = $bashCommand.Source
    } else {
        foreach ($candidate in @(
                "C:\Program Files\Git\bin\bash.exe",
                "C:\Program Files\Git\usr\bin\bash.exe"
            )) {
            if (Test-Path -LiteralPath $candidate) {
                $bashPath = $candidate
                break
            }
        }
    }

    $bashHasPython = $false
    if ($bashPath) {
        & $bashPath "-lc" "python3 -c 'import yaml' >/dev/null 2>&1 || python -c 'import yaml' >/dev/null 2>&1"
        $bashHasPython = $LASTEXITCODE -eq 0
    }

    if ($bashPath -and $bashHasPython) {
        Write-Host "Running repository content checks..."
        Push-Location $repoRoot
        try {
            & $bashPath "bin/check-content.sh"
            if ($LASTEXITCODE -ne 0) {
                throw "bin/check-content.sh failed."
            }
        } finally {
            Pop-Location
        }
    } else {
        Write-Warning "Bash content-check prerequisites are unavailable; running the PowerShell project-content checks instead."
        Test-ProjectFrontMatter
    }
}

Write-Host "Staging site changes..."
Invoke-Git @("add", "-A")
Invoke-Git @("diff", "--cached", "--check")

$stagedFiles = @(Invoke-Git @("diff", "--cached", "--name-only"))
if ($stagedFiles.Count -eq 0) {
    Write-Host "No changes to publish."
    exit 0
}

Write-Host "Creating commit..."
Invoke-Git @("commit", "-m", $Message) -UserName $commitAuthorName -UserEmail $commitAuthorEmail

Write-Host "Pushing to origin/$Branch..."
Invoke-Git @("push", "origin", $Branch)

Write-Host "Published successfully. GitHub Actions will build and deploy the site."
