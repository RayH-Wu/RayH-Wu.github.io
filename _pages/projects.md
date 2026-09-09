---
layout: page
title: projects
permalink: /projects/
nav: true
nav_order: 2
---

<style>
  .projects-showcase {
    margin-top: 2.5rem;
  }

  .projects-showcase-grid {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    column-gap: 3.5rem;
    row-gap: 4.5rem;
  }

  .project-showcase-item {
    min-width: 0;
  }

  .project-showcase-media {
    display: block;
    position: relative;
    width: 100%;
    aspect-ratio: 16 / 10;
    overflow: hidden;
    background: #f2f3f3;
  }

  .project-showcase-media img {
    display: block;
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform 180ms ease;
  }

  .project-showcase-item:hover .project-showcase-media img {
    transform: scale(1.02);
  }

  .project-showcase-title {
    margin: 1.15rem 0 0.45rem;
    color: var(--global-text-color);
    font-size: 1.18rem;
    font-weight: 500;
    line-height: 1.28;
    letter-spacing: 0;
  }

  .project-showcase-description {
    margin: 0;
    color: var(--global-text-color-light);
    font-size: 0.95rem;
    line-height: 1.55;
  }

  .project-showcase-link {
    display: inline-block;
    margin-top: 0.9rem;
    color: var(--global-text-color-light);
    font-size: 0.88rem;
    text-decoration: none;
  }

  .project-showcase-link:hover {
    color: var(--global-theme-color);
    text-decoration: none;
  }

  @media (max-width: 700px) {
    .projects-showcase {
      margin-top: 1.75rem;
    }

    .projects-showcase-grid {
      grid-template-columns: 1fr;
      row-gap: 3rem;
    }

    .project-showcase-title {
      font-size: 1.08rem;
    }
  }
</style>

<div class="projects-showcase">
  {% assign sorted_projects = site.projects | sort: "importance" %}
  <div class="projects-showcase-grid">
    {% for project in sorted_projects %}
      <article class="project-showcase-item">
        {% if project.img %}
          <a class="project-showcase-media" href="{{ project.url | relative_url }}" aria-label="View {{ project.title }}">
            <img src="{{ project.img | relative_url }}" alt="{{ project.title }}" loading="lazy" decoding="async">
          </a>
        {% endif %}
        <h2 class="project-showcase-title">{{ project.title }}</h2>
        {% if project.description %}
          <p class="project-showcase-description">{{ project.description }}</p>
        {% endif %}
        <a class="project-showcase-link" href="{{ project.url | relative_url }}">View project ↗</a>
      </article>
    {% endfor %}
  </div>
</div>
