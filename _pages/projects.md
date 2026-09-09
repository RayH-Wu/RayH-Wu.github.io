---
layout: page
title: projects
permalink: /projects/
description: Selected technical and competition projects. Publications are listed separately.
nav: true
nav_order: 2
---

<div class="projects">
  {% assign sorted_projects = site.projects | sort: "importance" %}
  <div class="row row-cols-1 row-cols-md-3">
    {% for project in sorted_projects %}
      {% include projects.liquid %}
    {% endfor %}
  </div>
</div>
