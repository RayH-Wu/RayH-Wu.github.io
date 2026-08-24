---
layout: about
title: about
permalink: /
subtitle:

selected_papers: true # lists papers.bib entries marked selected={true}
social: true # includes social icons at the bottom of the page

announcements:
  enabled: true # includes a list of news items
  scrollable: true # adds a vertical scroll bar if there are more than 3 news items
  limit: 5 # leave blank to include all the news in the `_news` folder

latest_posts:
  enabled: false # flip to true once you actually write blog posts
  scrollable: true
  limit: 3
---

<script>
  document.addEventListener("DOMContentLoaded", function () {
    const heading = document.querySelector(".post-title");
    if (heading) {
      heading.textContent = "Ruihan Wu（吴瑞涵）";
    }
  });
</script>

<div style="display:flex; gap:2rem; align-items:flex-start; flex-wrap:wrap; margin-top:0.5rem;">
  <div style="flex:1 1 520px; min-width:0;">
    <p>Hey there!</p>
    <p>I am Ruihan Wu, a senior undergraduate in Information Engineering at Southern University of Science and Technology (SUSTech).</p>

    <p>At Southern University of Science and Technology, I work with <a href="https://www.sustech.edu.cn/en/faculties/shuxiangguo.html">Prof. Shuxiang Guo</a> at the <a href="http://www.guolab.org/">Guo Lab</a>. I spent a semester at the University of Pennsylvania as an exchange student, and later I was lucky to work with <a href="https://haiminhu.org/">Prof. Haimin Hu</a> at Johns Hopkins University, where I joined the <a href="https://lcsr.jhu.edu/">Learning, Control, and Safety Robotics (LCSR) Lab</a> and the <a href="https://alliance-ai.cs.jhu.edu/">Alliance AI Lab</a>.</p>

    <p>My research interests broadly center on robotics and control. To me, exploring robotics is ultimately a process of understanding human nature and ourselves.</p>

  </div>

  <div style="flex:0 0 230px; max-width:230px; margin-top:0.25rem;">
    <img src="/assets/img/prof_pic.jpg" alt="Ruihan Wu" style="width:100%; height:auto; border-radius:6px; display:block; box-shadow:0 2px 10px rgba(0,0,0,0.12);">
  </div>
</div>
