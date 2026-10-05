while IFS="," read -r skos_file namespace
do
    filename="${skos_file##*/}"
    wget https://raw.githubusercontent.com/viaacode/datamodels/$branch/$skos_file
    import_file --uri-pattern $namespace/%s --to sqlite:///meemoo_atramhasis.sqlite --conceptscheme-uri $namespace $filename
    rm $filename
done < /data/data.csv