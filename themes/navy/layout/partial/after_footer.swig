<!-- Scripts -->
<!-- build:js build/js/main.js -->
{{ js('js/toc') }}
{{ js('js/mobile_nav') }}
<!-- endbuild -->
{% if page.layout === 'plugins' %}
<!-- Plugin search -->
<script src="https://cdn.bootcss.com/lunr.js/2.1.5/lunr.min.js"></script>
<!-- build:js build/js/plugins.js -->
{{ js('js/plugins') }}
<!-- endbuild -->
{% endif %}
