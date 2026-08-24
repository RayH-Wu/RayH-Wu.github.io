# 填内容速查

站点已经跑通，剩下的都是往固定位置填字。每一节给出：**改哪个文件 → 抄哪段 → 怎么验**。

发布流程永远是这三步：

```bash
cd /home/ray/Disk_ext/RayH-Wu.github.io
bash bin/check-content.sh        # 本地校验，通过再推
git add -A && git commit -m "..." && git push
```

推上去后 `Deploy site` 跑约 3 分钟，然后**硬刷新**浏览器（`Ctrl+Shift+R`），否则看到的是缓存。
站点地址：<https://rayh-wu.github.io>

---

## 1. 头像

把照片放成 `assets/img/prof_pic.jpg`（同名覆盖，方图最好）。
圆形裁切开关在 `_pages/about.md` 的 `image_circular`。

## 2. 首页文字

文件：`_pages/about.md`

- `subtitle:` —— 名字下面那行小字（职位 / 实验室 / 学校）
- `---` 之下的正文 —— 自我介绍，普通 Markdown，可以放链接和粗体
- 侧栏地址块 —— front matter 里的 `profile.more_info`，每行一个 `<p>`

文件里三处 `TODO` 注释标出了我没法替你写的部分（职位、导师、背景）。

## 3. 联系方式 / 社交图标

文件：`_data/socials.yml` —— 一行一个，留空或删掉就不显示那个图标。

已填：`email`、`github_username`。待填：`scholar_userid`、`linkedin_username`、`orcid_id`。

`scholar_userid` 取法：打开自己的 Google Scholar 主页，地址栏 `citations?user=XXXXXXXXXXXX` 里的 `XXXXXXXXXXXX`。

支持的键名不能自己编，以下是插件源码里的完整清单：

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

## 4. 论文

文件：`_bibliography/papers.bib`

> **先读这条**：BibTeX 里 `%` **不是**注释符号。只要文件里出现一个 at 符号，后面的内容就会被当成条目解析，写坏一条 = 整站构建失败。所以草稿写在这份文档里，成型了再贴进 `papers.bib`。

一条用满所有字段的模板（这份已用 CI 同款解析器 bibtex-ruby 实测通过，10 个 al-folio 专有字段全部被正确识别）：

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

字段含义：

| 字段                                                                 | 效果                                                       |
| -------------------------------------------------------------------- | ---------------------------------------------------------- |
| `abbr`                                                               | 左边那个彩色角标（ICRA / RSS / T-RO）                      |
| `selected`                                                           | `{true}` 时同时出现在首页的 selected publications          |
| `preview`                                                            | 缩略图，文件放 `assets/img/publication_preview/`，gif 最稳 |
| `pdf`                                                                | 完整 URL，或放在 `assets/pdf/` 下的文件名                  |
| `code` `website` `video` `poster` `slides` `supp` `html` `blog`      | 各自生成一个按钮                                           |
| `abstract`                                                           | 可展开的 Abstract 按钮                                     |
| `award`                                                              | 条目下方的高亮获奖行                                       |
| `bibtex_show`                                                        | `{true}` 时多一个 Bib 按钮，显示原始条目                   |
| `arxiv` `altmetric` `dimensions` `inspirehep_id` `google_scholar_id` | 引用数角标                                                 |

贴进第一条之后，把 `_pages/about.md` 里的 `selected_papers` 改回 `true`，首页才会出现 selected publications 那一栏（现在是 `false`，因为空栏只会渲染出一个光秃秃的标题）。

完整的官方示例（各种条目类型都有）在 `_bibliography/papers.bib.example`。

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

`inline: true` = 首页直接显示一行；`inline: false` 则需要额外加 `title:`，会生成独立页面，首页显示成可点击的标题。
首页显示几条由 `_pages/about.md` 的 `announcements.limit` 控制（现在是 5）。

## 6. CV

文件：`_data/cv.yml`，填完把 `_pages/cv.md` 的 `nav: false` 改成 `nav: true`，导航栏才会出现 CV。

现在只保留了 Education 和 Skills 两节。想加 Experience / Awards / Publications / Languages / Certificates / References，从 `_data/cv.yml.example` 里把对应段落抄过来 —— 那是官方完整示例。

**空的一节会渲染成一个只有标题的空壳**，所以没内容的段落保持注释状态。

## 7. 导航栏增减页面

每个页面 front matter 里的 `nav:` 控制是否出现在导航栏，`nav_order:` 控制顺序。

| 页面         | 文件                     | 现在                                                       |
| ------------ | ------------------------ | ---------------------------------------------------------- |
| about        | `_pages/about.md`        | 永远显示                                                   |
| publications | `_pages/publications.md` | `nav: true`（第 1 位）                                     |
| CV           | `_pages/cv.md`           | `nav: false`                                               |
| projects     | `_pages/projects.md`     | `nav: false`，内容放 `_projects/`                          |
| blog         | `_pages/blog.md`         | `nav: false`，文章放 `_posts/`，命名 `YYYY-MM-DD-title.md` |
| repositories | `_pages/repositories.md` | `nav: false`，仓库列表在 `_data/repositories.yml`          |
| teaching     | `_pages/teaching.md`     | `nav: false`，课程放 `_teachings/`                         |

## 8. 自定义域名（可选）

`ruihanwu.com` / `.me` / `.io` / `.dev` / `.net` / `.org` / `.xyz` 在 2026-08-24 时全部未被注册。买下之后：

```bash
sed -i 's|^url:.*|url: https://ruihanwu.com # the base hostname \& protocol for your site|' _config.yml
echo "ruihanwu.com" > CNAME
```

DNS 加四条 A 记录（`@` → `185.199.108.153` / `109.153` / `110.153` / `111.153`）和一条 CNAME（`www` → `rayh-wu.github.io`），然后在 Settings → Pages → Custom domain 填域名并勾 Enforce HTTPS。

---

## 出问题时

| 症状                           | 原因                                                  | 处理                                                                     |
| ------------------------------ | ----------------------------------------------------- | ------------------------------------------------------------------------ |
| 页面能开但**完全没有样式**     | `_config.yml` 的 `url` / `baseurl` 不对，资源路径 404 | 确认 `url: https://rayh-wu.github.io`、`baseurl:` 为空                   |
| `Deploy site` 红了             | 多半是 `papers.bib` 写坏                              | 看 Actions 日志里的 `Liquid Exception`；先跑 `bash bin/check-content.sh` |
| `Prettier code formatter` 红了 | 格式没对齐                                            | `npx prettier . --write` 后重新提交                                      |
| 改了但网页没变                 | 浏览器缓存                                            | `Ctrl+Shift+R`，或用无痕窗口                                             |

本机跑不了 `jekyll serve` 预览：al-folio v1.x 要 Ruby 3.3，这台机器是 3.0.2，也没装 docker。所有验证靠 `bin/check-content.sh` + GitHub Actions。
