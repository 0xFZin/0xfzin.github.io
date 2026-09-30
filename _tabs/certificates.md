---
title: Certifications
icon: fas fa-folder-open
order: 4
---

{% assign certs = site.pages | where: 'certificate_index', true | sort: 'order' %}

<div id="cert-list">
{% for p in certs %}
  {% assign count = site.posts | where: 'certificate', p.certificate | size %}

  {% assign src = nil %}
  {% if p.image %}
    {% assign src = p.image.path | default: p.image %}
    {% unless src contains '//' %}
      {% assign src = p.media_subpath | append: '/' | append: src | replace: '//', '/' | relative_url %}
    {% endunless %}
  {% endif %}

  <a href="{{ p.url | relative_url }}" class="cert-card">
    {% if src %}
      <div class="cert-card__img" role="img"
           aria-label="{{ p.image.alt | default: p.title | xml_escape }}"
           style="background-image: url('{{ src }}');"></div>
    {% endif %}
    <div class="cert-card__body">
      <h2 class="cert-card__title">{{ p.title }}</h2>
      <p class="cert-card__desc">{{ p.description }}</p>
      <div class="cert-card__meta">
        <i class="{{ p.icon }} fa-fw me-1"></i>
        {{ count }} {% if count == 1 %}post{% else %}posts{% endif %}
      </div>
    </div>
  </a>
{% endfor %}
</div>

<style>
  #cert-list { display: flex; flex-direction: column; gap: 1.25rem; }

  #cert-list a.cert-card {
    display: flex;
    flex-direction: row-reverse;      /* image on the right, like Home */
    min-height: 10rem;
    overflow: hidden;                 /* keeps the image inside the rounded box */
    border: 1px solid var(--card-border-color, rgba(128,128,128,.2));
    border-radius: .625rem;
    background: var(--card-bg, transparent);
    color: inherit;
    text-decoration: none;
    transition: box-shadow .2s;
  }
  #cert-list a.cert-card:hover { box-shadow: 0 0 10px rgba(0,0,0,.35); }

  .cert-card__img {
    flex: 0 0 40%;
    background-size: cover;
    background-position: center;
  }
  .cert-card__body {
    flex: 1;
    min-width: 0;
    display: flex;
    flex-direction: column;
    padding: 1.25rem 1.5rem;
  }
  .cert-card__title { font-size: 1.25rem; margin: 0 0 .5rem; color: var(--heading-color); }
  .cert-card__desc  { margin: 0; flex-grow: 1; color: var(--text-muted-color); }
  .cert-card__meta  { margin-top: 1rem; font-size: .85rem; color: var(--text-muted-color); }

  @media (max-width: 767.98px) {
    #cert-list a.cert-card { flex-direction: column; }
    .cert-card__img { flex-basis: auto; aspect-ratio: 40 / 21; }
  }
</style>
