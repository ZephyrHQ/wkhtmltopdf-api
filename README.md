Html2pdf MicroService
---------------------

The service write with Symfony, Snappy and Wkhtml.
The docker image is small and based on Alpine.
This service is swarm compliant and replicable on a cluster.

### Start the printer

    docker run --rm -p 9090:80 -e APP_ENV=dev --name=printer zephyrhq/wkhtmltopdf-saas

Test the render in a navigator :

    http://localhost:9090/print?html=test&disposition=inline&options[page-size]=A6

Naturally, it is better to use curl or another call url library.

### Options

The options could be send with GET or POST variables

- html: the content to print
- url: the url(s) to render, could be an array (ex: url[]='...'&url[]='...')
- filename: the name of return file
- disposition: attachment or inline
- options: all wkhtmltopdf options, the complete list take in charge is bellow

#### wkhtmltopdf options

    ignore-load-errors
    lowquality
    collate
    no-collate
    cookie-jar
    copies
    dpi
    extended-help
    grayscale
    help
    htmldoc
    image-dpi
    image-quality
    manpage
    margin-bottom
    margin-left
    margin-right
    margin-top
    orientation
    output-format
    page-height
    page-size
    page-width
    no-pdf-compression
    quiet
    read-args-from-stdin
    title
    use-xserver
    version
    dump-default-toc-xsl
    dump-outline
    outline
    no-outline
    outline-depth
    allow
    background
    no-background
    checkbox-checked-svg
    checkbox-svg
    cookie
    custom-header
    custom-header-propagation
    no-custom-header-propagation
    debug-javascript
    no-debug-javascript
    default-header
    encoding
    disable-external-links
    enable-external-links
    disable-forms
    enable-forms
    images
    no-images
    disable-internal-links
    enable-internal-links
    disable-javascript
    enable-javascript
    javascript-delay
    load-error-handling
    load-media-error-handling
    disable-local-file-access
    enable-local-file-access
    minimum-font-size
    exclude-from-outline
    include-in-outline
    page-offset
    password
    disable-plugins
    enable-plugins
    post
    post-file
    print-media-type
    no-print-media-type
    proxy
    radiobutton-checked-svg
    radiobutton-svg
    run-script
    disable-smart-shrinking
    enable-smart-shrinking
    stop-slow-scripts
    no-stop-slow-scripts
    disable-toc-back-links
    enable-toc-back-links
    user-style-sheet
    username
    window-status
    zoom
    footer-center
    footer-font-name
    footer-font-size
    footer-html
    footer-left
    footer-line
    no-footer-line
    footer-right
    footer-spacing
    header-center
    header-font-name
    header-font-size
    header-html
    header-left
    header-line
    no-header-line
    header-right
    header-spacing
    replace
    disable-dotted-lines
    cover
    toc
    toc-depth
    toc-font-name
    toc-l1-font-size
    toc-header-text
    toc-header-font-name
    toc-header-font-size
    toc-level-indentation
    disable-toc-links
    toc-text-size-shrink
    xsl-style-sheet
    viewport-size
    redirect-delay
    cache-dir
    keep-relative-links
    resolve-relative-links
