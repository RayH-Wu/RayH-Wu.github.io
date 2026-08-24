# 填内容速查

站点已跑通，剩下的都是往固定位置填字。每节给出：**改哪个文件 → 抄哪段 → 有什么坑**。

发布流程永远是这三步：

```bash
cd /home/ray/Disk_ext/RayH-Wu.github.io
bash bin/check-content.sh        # 本地校验，通过再推
git add -A && git commit -m "..." && git push
```

推上去后 `Deploy site` 跑约 3 分钟，然后**硬刷新**浏览器（`Ctrl+Shift+R`），否则看到的是缓存。
站点：<https://rayh-wu.github.io>

## 当前哪些是占位、必须替换

| 位置                                                 | 现在是什么                                                        | 换成什么                                                  |
| ---------------------------------------------------- | ----------------------------------------------------------------- | --------------------------------------------------------- |
| `assets/img/prof_pic.jpg`                            | 模板自带的爱因斯坦照片                                            | 你的证件照，同名覆盖                                      |
| `assets/img/publication_preview/safety-game.gif`     | 我用 matplotlib 画的示意动画                                      | 真实渲染；重画用 `python3 bin/make_preview.py <输出路径>` |
| `_bibliography/papers.bib` 里那条 `wu2026turning`    | 按你 ICRA 手稿标题写的占位，作者只列了你一人，venue 标 `Preprint` | 真实作者和 venue；不想现在公开就整条删掉                  |
| `_projects/1_safety_filter.md`、`2_placeholder.md`   | 占位项目卡                                                        | 真实项目，或删掉                                          |
| `_data/cv.yml`                                       | 只有骨架，大量 `TODO`                                             | 真实履历                                                  |
| `_pages/about.md` 的 `subtitle` 和正文里 3 处 `TODO` | 职位/导师/背景空着                                                | 你的真实信息                                              |

---

## 1. 首页文字

文件：`_pages/about.md`

- `subtitle:` —— 名字下面那行小字（职位 / 实验室 / 学校）
- `---` 之下的正文 —— 普通 Markdown
- 右侧地址块 —— front matter 里的 `profile.more_info`，每行一个 `<p>`
- `profile.image_circular` —— 头像是否裁成圆形
- `announcements.limit` —— 首页显示几条 news（现在 5）
- `selected_papers: true` —— 首页底部的 selected publications 栏，已开启

## 2. 联系方式 / 社交图标

文件：`_data/socials.yml` —— 一行一个，留空或删掉就不显示那个图标。

已填：`email`、`github_username`。待填：`scholar_userid`、`linkedin_username`、`orcid_id`。

`scholar_userid` 取法：打开自己的 Google Scholar 主页，地址栏 `citations?user=XXXXXXXXXXXX` 里的那串。

键名不能自己编，以下是插件源码里的完整清单：

```
academia_edu  acm_id  arxiv_id  blogger_url  bluesky_url  cv_pdf  dblp_url
discord_id  email  facebook_id  flickr_id  github_username  gitlab_username
hal_id  ieee_id  inspirehep_id  instagram_id  kaggle_id  keybase_username
lastfm_id  lattes_id  leetcode_id  letterboxd_id  linkedin_username
mastodon_username  medium_username  orcid_id  osf_id  pinterest_id  publons_id
quora_username  research_gate_profile  rss_icon  scholar_userid  scopus_id
semanticscholar_id  spotify_id  stackoverflow_id  strava_userid
telegram_username  unsplash_id  wechat_username  whatsapp_number  wikidata_id
wikipedia_id  work_url  x_username  youtube_id  zotero_username  custom_social
```

## 3. 论文（首页底部 + publications 页）

文件：`_bibliography/papers.bib`

> **先读这条**：BibTeX 里 `%` **不是**注释符号。只要文件里出现一个 at 符号，后面就会被当成条目解析，写坏一条 = 整站构建失败。草稿写在这份文档里，成型了再贴进去。

一条用满字段的模板（已用 CI 同款解析器 bibtex-ruby 实测通过，14 个字段全部被正确识别）：

```bibtex
@inproceedings{wu2027turning,
  title       = {Turning Safety into Competency: Equilibrium-Preserving Play in Multi-Robot Interaction},
  author      = {Wu, Ruihan and Coauthor, A. and Coauthor, B.},
  booktitle   = {IEEE International Conference on Robotics and Automation (ICRA)},
  year        = {2027},
  abbr        = {ICRA},
  selected    = {true},
  preview     = {dogfight.gif},
  abstract    = {One paragraph. Renders as an expandable Abstract button.},
  pdf         = {https://arxiv.org/abs/0000.00000},
  code        = {https://github.com/RayH-Wu/example},
  video       = {https://youtu.be/example},
  website     = {https://rayh-wu.github.io/},
  award       = {Best Paper Finalist},
  bibtex_show = {true},
}
```

| 字段                                                                 | 效果                                                                |
| -------------------------------------------------------------------- | ------------------------------------------------------------------- |
| `abbr`                                                               | 左边那个彩色角标（ICRA / RSS / T-RO / Preprint）                    |
| `selected`                                                           | `{true}` 时同时出现在**首页底部**的 selected publications           |
| `preview`                                                            | 缩略图/动图，文件放 `assets/img/publication_preview/`，gif 直接会动 |
| `pdf`                                                                | 完整 URL，或放在 `assets/pdf/` 下的文件名                           |
| `code` `website` `video` `poster` `slides` `supp` `html` `blog`      | 各自生成一个按钮                                                    |
| `abstract`                                                           | 可展开的 Abstract 按钮                                              |
| `award`                                                              | 条目下方的高亮获奖行                                                |
| `bibtex_show`                                                        | `{true}` 时多一个 Bib 按钮，显示原始条目                            |
| `arxiv` `altmetric` `dimensions` `inspirehep_id` `google_scholar_id` | 引用数角标                                                          |

条目按 `year` 自动分组倒序，不用手动排。作者名超过 3 个会折叠成「N more authors」，阈值是 `_config.yml` 的 `max_author_limit`。

完整的官方示例（各种条目类型）在 `_bibliography/papers.bib.example`。

## 4. Projects

页面：`_pages/projects.md`（导航栏第 2 位）；内容：`_projects/` 下一个文件一张卡。

```markdown
---
layout: page
title: 项目名
description: 卡片上的一行说明
img: assets/img/publication_preview/safety-game.gif
importance: 1
category: research
---

正文，普通 Markdown。
```

| 字段         | 说明                                                                                                          |
| ------------ | ------------------------------------------------------------------------------------------------------------- |
| `img`        | 卡片缩略图，jpg / png / gif 都行                                                                              |
| `importance` | 同一分类内的排序，升序                                                                                        |
| `category`   | **必须**命中 `_pages/projects.md` 里 `display_categories` 的某一项，现在只有 `research`；想分多类就在那行里加 |
| `redirect`   | 可选，填了卡片就直接跳外链，不生成详情页                                                                      |

正文里插图用 `{% include figure.liquid path="assets/img/xxx.png" class="img-fluid rounded z-depth-1" %}`，`1_safety_filter.md` 里有现成例子。

## 5. News

一条新闻一个文件，命名 `_news/YYYY-MM-DD-短横线标题.md`：

```markdown
---
layout: post
date: 2026-09-01 10:00:00-0500
inline: true
related_posts: false
---

Paper accepted at ICRA 2027.
```

`inline: true` = 首页直接显示一行（正文支持 Markdown 和 emoji）。
`inline: false` 则要额外加 `title:`，会生成独立页面，首页显示成可点击标题。
全部新闻的归档页在 `/news/`。

## 6. CV

文件：`_data/cv.yml`（导航栏第 3 位已放出）。

现在只有 Education 和 Skills 两节，且 Education 里全是 `TODO`。想加 Experience / Awards / Publications / Languages / Certificates / References，从 `_data/cv.yml.example` 里把对应段落抄过来 —— 那是官方完整示例。

**空的一节会渲染成一个只有标题的空壳**，所以没内容的段落保持注释状态。

想改成「直接挂一个 PDF」：把 PDF 放进 `assets/pdf/`，然后在 `_data/socials.yml` 里取消注释 `cv_pdf: /assets/pdf/cv.pdf`。

## 7. 导航栏增减页面

每个页面 front matter 里的 `nav:` 控制是否出现，`nav_order:` 控制顺序。

| 页面         | 文件                     | 现在                                                       |
| ------------ | ------------------------ | ---------------------------------------------------------- |
| about        | `_pages/about.md`        | 永远显示                                                   |
| publications | `_pages/publications.md` | `nav: true`，第 1 位                                       |
| projects     | `_pages/projects.md`     | `nav: true`，第 2 位                                       |
| CV           | `_pages/cv.md`           | `nav: true`，第 3 位                                       |
| blog         | `_pages/blog.md`         | `nav: false`，文章放 `_posts/`，命名 `YYYY-MM-DD-title.md` |
| repositories | `_pages/repositories.md` | `nav: false`，仓库列表在 `_data/repositories.yml`          |
| teaching     | `_pages/teaching.md`     | `nav: false`，课程放 `_teachings/`                         |

## 8. 自定义域名（可选）

`ruihanwu.com` / `.me` / `.io` / `.dev` / `.net` / `.org` / `.xyz` 在 2026-08-24 时全部未被注册。买下之后：

```bash
sed -i 's|^url:.*|url: https://ruihanwu.com # the base hostname \& protocol for your site|' _config.yml
echo "ruihanwu.com" > CNAME
```

DNS 加四条 A 记录（`@` → `185.199.108.153` / `109.153` / `110.153` / `111.153`）和一条 CNAME（`www` → `rayh-wu.github.io`），然后 Settings → Pages → Custom domain 填域名并勾 Enforce HTTPS。

---

## 出问题时

| 症状                                 | 原因                                                  | 处理                                                                  |
| ------------------------------------ | ----------------------------------------------------- | --------------------------------------------------------------------- |
| 页面能开但**完全没有样式**           | `_config.yml` 的 `url` / `baseurl` 不对，资源路径 404 | 确认 `url: https://rayh-wu.github.io`、`baseurl:` 为空                |
| `Deploy site` 红了                   | 多半是 `papers.bib` 写坏                              | Actions 日志里找 `Liquid Exception`；先跑 `bash bin/check-content.sh` |
| `Prettier code formatter` 红了       | 格式没对齐                                            | `npx prettier . --write` 后重新提交                                   |
| projects 页空白                      | 卡片的 `category` 没命中 `display_categories`         | 两处对齐                                                              |
| selected publications 只有标题没内容 | 没有 `selected = {true}` 的条目                       | 给条目加上，或把 `about.md` 的 `selected_papers` 关掉                 |
| 改了但网页没变                       | 浏览器缓存                                            | `Ctrl+Shift+R`，或用无痕窗口                                          |

本机跑不了 `jekyll serve` 预览：al-folio v1.x 要 Ruby 3.3，这台机器是 3.0.2，也没装 docker。所有验证靠 `bin/check-content.sh` + GitHub Actions。
