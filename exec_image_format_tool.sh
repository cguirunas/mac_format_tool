#!/bin/bash

function chooseMethod () {
    clear
    echo
    echo " ####################################################################################################################"
    echo " #######  OSX FORMAT TOOL  ################################################################ DISK SELECTED: /DEV/DISK$DISK #"
    echo " ####################################################################################################################"
    echo
    echo "   SELECTED DISK: /DEV/DISK($DISK)   (This disk will be formatted with the .ISO, .IMG or .DMG file)"
    if test "${DISK+true}"; then
        diskutil info /dev/disk$DISK | grep "Device / Media Name:"
        diskutil info /dev/disk$DISK | grep "Disk Size:"
    fi
    
    echo
    echo "   SELECTED .ISO FILE: ($ISO)        (This .ISO file will be used to format the DISK($DISK))"
    echo "   SELECTED .IMG FILE: ($IMG)        (This .IMG file will be used to format the DISK($DISK))"
    echo "   SELECTED .DMG FILE: ($DMG)        (This .DMG file will be used to format the DISK($DISK))"
    echo
    echo "[10] - LIST DISKS AND SELECT THE DISK($DISK) TO BE FORMATTED"
    echo "[11] - SELECT .ISO FILE AT $PWD     (Select this file if you're going to use a .ISO file to format)"
    echo "[12] - SELECT .IMG FILE AT $PWD     (Select this file if you're going to use a .IMG file to format)"
    echo "[13] - SELECT .DMG FILE AT $PWD     (Select this file if you're going to use a .DMG file to format)"
    echo 
    echo "[20] - UNMOUNT DISK ($DISK)       (You need to EJECT the DISK$DISK before to FORMAT)" 
    echo "[21] - EJECT DISK ($DISK)"         
    echo
    echo "[30] - CONVERT .ISO($ISO) TO .IMG($IMG)"
    echo
    echo "[40] - FORMAT DISK ($DISK) USING IMAGE FROM .IMG($IMG)" 
    echo "[41] - FORMAT DISK ($DISK) USING IMAGE FROM .DMG($DMG)" 
    echo
    echo "[?] - HELP"
    echo
    echo "[*]  - Don't know, "
    echo
    read -n3 -p " Choose your option (pass any other key to exit) " option
    case $option in
        10) echo " - LIST DISKS AND SELECT THE DISK($DISK) TO BE FORMATTED" ; chooseLISTDISKS $DISK $ISO $IMG $DMG; exit ;;
        11) echo " - SELECT .ISO($ISO) FILE AT $PWD" ; chooseISO $DISK $ISO $IMG $DMG; exit ;;
        12) echo " - SELECT .IMG($IMG) FILE AT $PWD" ; chooseIMG $DISK $ISO $IMG $DMG; exit ;;
        13) echo " - SELECT .DMG($DMG) FILE AT $PWD" ; chooseIMG $DISK $ISO $IMG $DMG; exit ;;
        20) echo " - UNMOUNT DISK ($DISK)" ; chooseUNMOUNT $DISK $ISO $IMG; exit ;;
        21) echo " - EJECT DISK ($DISK)" ; chooseEJECT $DISK $ISO $IMG $DMG; exit ;;
        30) echo " - CONVERT .ISO($ISO) TO .IMG($IMG)" ; chooseCONVERT_ISO_IMG $DISK $ISO $IMG $DMG ; exit ;;
        40) echo " - FORMAT DISK ($DISK) USING IMAGE FROM .IMG($IMG)" ; chooseFORMAT_IMG $DISK $ISO $IMG $DMG ; exit ;;
        41) echo " - FORMAT DISK ($DISK) USING IMAGE FROM .DMG($DMG)" ; chooseFORMAT_DMG $DISK $ISO $IMG $DMG ; exit ;;
        
        ?) echo  " - HELP" ; chooseHELP $DISK $ISO $IMG $DMG; exit ;;
        *) echo  " - I don't know" ; chooseMethod $DISK $ISO $IMG $DMG ;  exit ;;
    esac
}

function chooseLISTDISKS () {
    echo "-------------------------------------------------"
    echo 
    diskutil list
    echo 
    echo "### PLEASE, WHICH DISK WOULD YOU LIKE TO USE? (FOR DISK1 TYPE 1, FOR DISK2 TYPE 2 AND SO ON)"
    read DISK
    echo 
    echo 
    echo "HEY! ARE YOU SURE? THE SIZE OF THE DISK$DISK IS:"
    diskutil info /dev/disk$DISK | grep "Device / Media Name:"
    diskutil info /dev/disk$DISK | grep "Disk Size:"
    echo 
    echo "DO YOU WANT TO CONTINUE? (CTRL+C TO CANCEL)"
    read -r 
    chooseMethod DISK ISO IMG DMG
}

function chooseISO () {
    echo "-------------------------------------------------"
    ls -lsa *.iso
    echo
    echo 
    echo "### PLEASE, WHICH ISO FILE WOULD YOU LIKE TO USE? (COPY AND PASTE HERE)"
    read ISO

    if test -f "$ISO"; then
        echo "$ISO exists."
    else 
        echo 
        echo "### SORRY, THIS FILE DOESN'T EXISTS, PLEASE SELECT THE RIGHT NAME AGAIN"
        chooseISO DISK ISO IMG DMG
    fi

    chooseMethod DISK ISO IMG DMG
}

function chooseIMG () {
    echo "-------------------------------------------------"
    ls -lsa *.img
    echo 
    echo 
    echo "### PLEASE, WHICH .IMG FILE WOULD YOU LIKE TO USE? (COPY AND PASTE HERE)"
    read IMG

    if test -f "$IMG"; then
        echo "$IMG exists."
    else 
        echo 
        echo "### SORRY, THIS FILE DOESN'T EXISTS, PLEASE SELECT THE RIGHT NAME AGAIN"
        chooseIMG DISK IMG IMG DMG
    fi

    chooseMethod DISK ISO IMG DMG
}

function chooseDMG () {
    echo "-------------------------------------------------"
    ls -lsa *.dmg
    echo 
    echo 
    echo "### PLEASE, WHICH .IMG FILE WOULD YOU LIKE TO USE? (COPY AND PASTE HERE)"
    read DMG

    if test -f "$DMG"; then
        echo "$DMG exists."
    else 
        echo 
        echo "### SORRY, THIS FILE DOESN'T EXISTS, PLEASE SELECT THE RIGHT NAME AGAIN"
        chooseDMG DISK ISO IMG DMG
    fi

    chooseMethod DISK ISO IMG DMG
}

function chooseUNMOUNT () {
    echo "-------------------------------------------------"
    
    # CHECK IS DISK IS SELECTED
    if test ! "${DISK+true}"; then
        echo "You must SELECT the DISK before UNMOUNT it (Please, verify the options of this FORMAT TOOL to do this STEP)"
        read -r
        chooseMethod DISK ISO IMG DMG
    else
        echo "UNMOUNT DISK($DISK)..."
    fi
    
    echo "PLEASE WAIT..."
    diskutil unmountDisk /dev/disk$DISK
    echo "Done!"
    read -r 
    chooseMethod DISK ISO IMG DMG
}

function chooseEJECT () {
    echo "-------------------------------------------------"
    
    # CHECK IS DISK IS SELECTED
    if test ! "${DISK+true}"; then
        echo "You must SELECT the DISK before EJECT it (Please, verify the options of this FORMAT TOOL to do that STEP)"
        read -r
        chooseMethod DISK ISO IMG DMG
    else
        echo "EJECTING DISK($DISK)..."
    fi

    echo "PLEASE WAIT..."
    diskutil eject /dev/disk$DISK
    echo "Done!"
    read -r

    chooseMethod DISK ISO IMG DMG
}

function chooseCONVERT_ISO_IMG () {
    echo "-------------------------------------------------"
    
    # CHECK IMG AND ISO
    if test ! "${ISO+true}"; then
        echo "You must SELECT the .ISO FILE before (Please, verify the options of this FORMAT TOOL to do that STEP)"
        read -r
        chooseMethod DISK ISO IMG DMG
    else
        if test ! "${IMG+true}"; then
            echo "You must SELECT a .IMG file before OR TYPE a new name to CREATE a file from the .ISO file."
            echo "Please, TYPE the new name of the .IMG file (e.g.: filexxx.img) OR do CTRL+C to go back to the menu:"
            read IMG
            chooseCONVERT_ISO_IMG DISK ISO IMG DMG
        else
            echo "CONVERTING ISO TO IMG..."
        fi    
    fi
    
    echo "PLEASE WAIT..."
    hdiutil convert -format UDRW -o $IMG $ISO
    echo "RENAMING FILE $IMG.DMG TO $IMG..."
    mv $IMG.dmg $IMG
    echo "Done!"
    read -r
    chooseMethod DISK ISO IMG DMG
}

function chooseFORMAT_IMG () {
    echo "-------------------------------------------------"

    if test ! "${DISK+true}"; then
        echo "You must SELECT the DISK($DISK) before (Please, verify the options of this FORMAT TOOL to do that STEP)"
        read -r
        chooseMethod DISK ISO IMG DMG
    else
        
        if test ! "${IMG+true}"; then
            echo "You must SELECT the .IMG($IMG) file before (Please, verify the options of this FORMAT TOOL to do that STEP)"
            read -r
            chooseMethod DISK ISO IMG DMG
        else

            # CHECK IS DISK IS SELECTED
            if test ! "${DISK+true}"; then
                echo "You must SELECT the DISK before UNMOUNT it (Please, verify the options of this FORMAT TOOL to do this STEP)"
                read -r
                chooseMethod DISK ISO IMG DMG
            else
                echo "UNMOUNT DISK($DISK)..."
            fi
            
            echo "PLEASE WAIT..."
            diskutil unmountDisk /dev/disk$DISK
            echo "Done!"

            echo "FORMATTING DISK($DISK) WITH THE .IMG($IMG) FILE..."
        fi
    fi

    echo "PLEASE WAIT..."
    sudo dd if=$IMG of=/dev/rdisk$DISK bs=1m
    echo "Done!"
    read -r
    chooseMethod DISK ISO IMG DMG
}

function chooseFORMAT_DMG () {
    echo "-------------------------------------------------"

    if test ! "${DISK+true}"; then
        echo "You must SELECT the DISK before (Please, verify the options of this FORMAT TOOL to do that STEP)"
        read -r
        chooseMethod DISK ISO IMG DMG
    else
        
        if test ! "${DMG+true}"; then
            echo "You must SELECT the .DMG file before (Please, verify the options of this FORMAT TOOL to do that STEP)"
            read -r
            chooseMethod DISK ISO IMG DMG
        else

            # CHECK IS DISK IS SELECTED
            if test ! "${DISK+true}"; then
                echo "You must SELECT the DISK before UNMOUNT it (Please, verify the options of this FORMAT TOOL to do this STEP)"
                read -r
                chooseMethod DISK ISO IMG DMG
            else
                echo "UNMOUNT DISK($DISK)..."
            fi
            
            echo "PLEASE WAIT..."
            diskutil unmountDisk /dev/disk$DISK
            echo "Done!"

            echo "FORMATTING $DISK WITH THE .DMG($DMG) FILE..."
        fi
    fi

    chooseUNMOUNT DISK ISO IMG DMG

    echo "PLEASE WAIT..."
    sudo dd if=$DMG of=/dev/rdisk$DISK bs=1m
    echo "Done!"
    read -r
    chooseMethod DISK ISO IMG DMG
}

function chooseHELP () {
    echo "-------------------------------------------------"
    echo "HELP"
    
    echo "To format a disk usging an image, you need to select a DISK and a ISO/IMG/DMG image file."
    echo 
    echo "If you have a .ISO file, you must convert it to a .IMG file. You can use the CONVERT option to do that."
    echo 
    echo "You need to UNMOUNT the selected disk BEFORE format that."
    echo 
    echo "CTRL+C can STOP this FORMAT TOOL at anytime."
    echo 
    read -r
    chooseMethod DISK ISO IMG DMG
}

chooseMethod 
