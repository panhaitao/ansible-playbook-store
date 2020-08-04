    #!/bin/sh
    while inotifywait -e create /home/inventory/initcsv; do
      sed '/^\"EE/d' Filein > fileout #how to capture File name?
      mv fileout /home/inventory/csvstorage
    fi
    done


/usr/bin/inotifywait -m -o log.txt --timefmt '%d/%m/%y/%H:%M' --format '%T %w %f' -e modify,delete,create,attrib var
