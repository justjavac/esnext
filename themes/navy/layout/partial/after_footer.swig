<!-- Scripts -->
<script async defer src="https://cdn.bootcss.com/jquery/3.3.1/jquery.slim.min.js"></script>
<script async defer src="https://cdn.bootcss.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
<!-- build:js build/js/main.js async defer -->
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
