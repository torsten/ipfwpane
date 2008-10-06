#!/usr/bin/env ruby

# This script unpacks the javascript libraries script.aculo.us and FancyZoom.


fancy_zoom    = 'FancyZoom 1.1'
scriptaculous = 'scriptaculous-js-1.8.1'
js_dir        = 'Website/js'


# Unpack the stuff to the right places

`rm -rf #{js_dir}`

`mkdir -p #{js_dir}/tmp`
`mkdir -p #{js_dir}/fancyimages`

`cd #{js_dir}/tmp && unzip '../../#{fancy_zoom}.zip'`
`cd #{js_dir}/tmp && unzip '../../#{scriptaculous}.zip'`


`mv -f '#{js_dir}/tmp/#{fancy_zoom}/js-global/FancyZoom'*.js #{js_dir}`
`mv -f '#{js_dir}/tmp/#{fancy_zoom}/images-global/zoom/'* #{js_dir}/fancyimages`


`mv -f '#{js_dir}/tmp/#{scriptaculous}/lib/'*.js #{js_dir}`
`mv -f '#{js_dir}/tmp/#{scriptaculous}/src/'*.js #{js_dir}`


# Patch FancyZoom.

fz_js = "#{js_dir}/FancyZoom.js"

patched = File.read(fz_js).
  gsub('/images-global/zoom/', 'js/fancyimages/')

File.open(fz_js, 'wb') do |file|
  file.write patched
end


# Clean up.

`rm -rf #{js_dir}/tmp`
