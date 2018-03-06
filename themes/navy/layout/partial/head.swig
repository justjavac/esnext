<head prefix="og: http://ogp.me/ns#">
  <meta charset="utf-8">
  <title>{% if page.title %}{{ page.title }} | {% endif %}{{ config.title }}</title>
  <meta name="renderer" content="webkit" />
  <meta name="force-rendering" content="webkit" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <!-- Canonical links -->
  <link rel="canonical" href="{{ url }}">
  <!-- Icon -->
  <link rel="apple-touch-icon" sizes="57x57" href="{{ url_for('icon/apple-icon-57x57.png') }}">
  <link rel="apple-touch-icon" sizes="60x60" href="{{ url_for('icon/apple-icon-60x60.png') }}">
  <link rel="apple-touch-icon" sizes="72x72" href="{{ url_for('icon/apple-icon-72x72.png') }}">
  <link rel="apple-touch-icon" sizes="76x76" href="{{ url_for('icon/apple-icon-76x76.png') }}">
  <link rel="apple-touch-icon" sizes="114x114" href="{{ url_for('icon/apple-icon-114x114.png') }}">
  <link rel="apple-touch-icon" sizes="120x120" href="{{ url_for('icon/apple-icon-120x120.png') }}">
  <link rel="apple-touch-icon" sizes="144x144" href="{{ url_for('icon/apple-icon-144x144.png') }}">
  <link rel="apple-touch-icon" sizes="152x152" href="{{ url_for('icon/apple-icon-152x152.png') }}">
  <link rel="apple-touch-icon" sizes="180x180" href="{{ url_for('icon/apple-icon-180x180.png') }}">
  <link rel="icon" type="image/png" sizes="192x192"  href="{{ url_for('icon/android-icon-192x192.png') }}">
  <link rel="icon" type="image/png" sizes="32x32" href="{{ url_for('icon/favicon-32x32.png') }}">
  <link rel="icon" type="image/png" sizes="96x96" href="{{ url_for('icon/favicon-96x96.png') }}">
  <link rel="icon" type="image/png" sizes="16x16" href="{{ url_for('icon/favicon-16x16.png') }}">
  <link rel="manifest" href="/manifest.json">
  <meta name="msapplication-TileColor" content="#2f83cd">
  <meta name="msapplication-TileImage" content="{{ url_for('icon/ms-icon-144x144.png') }}">
  <meta name="theme-color" content="#2f83cd">
  <!-- CSS -->
  <!-- build:css build/css/navy.css -->
  {{ css('css/navy') }}
  <!-- endbuild -->
  <link rel="stylesheet" href="https://cdn.bootcss.com/font-awesome/4.7.0/css/font-awesome.min.css">
  <!-- RSS -->
  {{ feed_tag('atom.xml') }}
  <!-- Open Graph -->
  {{ open_graph({
    twitter_site: config.twitter
  }) }}
 <script>
    var _hmt = _hmt || [];
    (function() {
      var hm = document.createElement("script");
      hm.src = "https://hm.baidu.com/hm.js?1f336f31cd6db48ca0ad520a9c7e4c57";
      var s = document.getElementsByTagName("script")[0]; 
      s.parentNode.insertBefore(hm, s);
    })();
  </script>

  <script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
  <script>
    (adsbygoogle = window.adsbygoogle || []).push({
      google_ad_client: "ca-pub-5061364613986259",
      enable_page_level_ads: true
    });
  </script>
</head>
