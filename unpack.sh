
set -Eeuo pipefail

if [ "$#" -ne 2 ]; then
    echo "ERROR: You must provide two numerical inputs to the script -- the season number and the unit number."
    echo "ex: Winter 21 Unit 1 files all start with bsflv30ku1. So season number = 30, unit number = 1."
    echo "    In this example, invoke the script like:"
    echo "        ./unpack.sh 30 1"
    exit 1
fi

# Unzip files
echo "Unzipping files..."
for file in *.zip
do
	unzip $file
done
rm *.zip
echo "Successfully unzipped files"

COMMONSEGMENT="bsflv$1ku$2"
echo "Interpreting common starting segment as $COMMONSEGMENT"
echo "Renaming folders..."

# Outlines
mv "${COMMONSEGMENT}_bundle_g1-2_esv" "Outlines Grades 1-2"
mv "${COMMONSEGMENT}_bundle_g3-4_esv" "Outlines Grades 3-4"
mv "${COMMONSEGMENT}_bundle_g5-6_esv" "Outlines Grades 5-6"

# Special buddies
mv "${COMMONSEGMENT}_bundle_spb" "Special Buddies (Condensed Outlines)"

# Videos
mv "${COMMONSEGMENT}_video_g1-6" "Videos"

# Leader packs
mv "${COMMONSEGMENT}ures_leaderpack_g1-2" "Leader Pack Grades 1-2"
mv "${COMMONSEGMENT}ures_leaderpack_g3-4" "Leader Pack Grades 3-4"
mv "${COMMONSEGMENT}ures_leaderpack_gr5-6" "Leader Pack Grades 5-6"

# The following folders exist in the first unit of every season only
if [ "$2" -eq 1 ]; then

    # Music and print extras
    mv "${COMMONSEGMENT}umpe_printextras_g1-6" "Music and Print Extras"

fi

echo "Successfully renamed folders"
echo "Renaming files in the Videos and Outlines folders..."

# Rename videos
cd Videos
for i in {1..6}
do
    BIBLESTORY="${COMMONSEGMENT}s${i}_vid_g1-6_biblestory.mp4"
    LIFEACTION="${COMMONSEGMENT}s${i}_vid_g1-6_lifeaction.mp4"
    
    # If the file exists, rename it
    if [ -f $BIBLESTORY ]; then 
        mv $BIBLESTORY "Bible_Story_${i}.mp4"
        mv $LIFEACTION "Life_Action_${i}.mp4"
    fi
done
cd ..

# Rename Outlines
declare -a AGEGROUPS=("1-2" "3-4" "5-6")
for AGEGROUP in "${AGEGROUPS[@]}"
do
    cd "Outlines Grades ${AGEGROUP}" 
        if [ "$2" -eq 1 ]; then
            mv "${COMMONSEGMENT}_actv_g${AGEGROUP}_esv.pdf" "Activity_Sheets_Aggregate.pdf"
            mv "${COMMONSEGMENT}_ldr_g${AGEGROUP}_esv.pdf" "Leader_Guides_Aggregate.pdf"
        fi
        
        for i in {1..6}
        do
           ACTIVITY="${COMMONSEGMENT}s${i}_actv_g${AGEGROUP}_esv.pdf"
           LEADERGUIDE="${COMMONSEGMENT}s${i}_ldr_g${AGEGROUP}_esv.pdf"
           
           if [ -f $ACTIVITY ]; then
               mv $ACTIVITY "Activity_Sheet_${i}.pdf"
               mv $LEADERGUIDE "Leader_Guide_${i}.pdf"
           fi 
        done

    cd ..
done

echo "Successfully renamed files in the Videos and Outlines folders"
echo "Successfully completed everything"

