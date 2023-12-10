AGE_TO_COMPRESS=3600 # 1 day
CIRCLE_DAY=108000 # 30 days
# list of file to compress
LOG_FILES="~/redmine/app ~/redmine/db"

# Any file older than EDGE_DATE must be compressed
NOW=$( date +%s )
EDGE_DATE=$(( NOW - AGE_TO_COMPRESS ))

for file in $LOG_FILES ; do
    # check if file exists
    if [ -e "$file" ] ; then 

        # compare "modified date" of file to EDGE_DATE
        if [ $( stat -c %Y "$file" ) -lt ${EDGE_DATE} ] ; then

            # create tar file of a single file
            # this is an odd way to compress a file
            tar -cvzf $file.tar.gz $file
           
        fi
        if [ $( stat -c %Y "$file" ) -lt ${CIRCLE_DAY} ] ; then

            # create tar file of a single file
            # this is an odd way to compress a file
            rm $file
           
        fi

    fi
done