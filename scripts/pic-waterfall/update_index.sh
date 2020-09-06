#!/bin/bash

filename=index.html

cat > $filename <<EOF  
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>2020年中游相册</title>
        <link rel="stylesheet" type="text/css" href="style.css">
        <script src="jquery-1.11.2.min.js" type="text/javascript"></script>
        <script src="jquery.lazyload.min.js" type="text/javascript"></script>
        <script src="waterfall.js" type="text/javascript"></script>
    </head>
  <body>
    <div class="masonry">
EOF

for pic in `ls images/*`
do
cat >> $filename <<EOF  
  <div class="item">
    <img class="lazy" src="$pic" alt="" />
  </div>
EOF
done

cat >> $filename <<EOF  
    </div>
  </body>
</html>
EOF
