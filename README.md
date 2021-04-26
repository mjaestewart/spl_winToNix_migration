# spl_winToNix_migration

This script `/bin/win_migrate.bat` copies Splunk Buckets from Windows to Linux.

## **Global Variables**

- `MaxVal=999`
  - This is the MaxVal Bucket Number you would like to set
- `MinVal=600`
  - This is the minVal bucket Number that you would like to set
- `Count=0`
  - Do not change. This is just a value to start incrementing from
- `SplunkPath=C:\Program Files\splunk\var\lib\splunk`
  - This is the default Splunk bucket root directory. Change this to the path of the bucket root dir.
- `nixServer=splunk@adv-rhel-spl-idx1.advanced.lab:/tmp/`
- `splunkData="/cygdrive/c/Program Files/splunk/var/lib/splunk`
  - This is the splunk bucket root dir for rsync. Keep `/cygdrive/DRIVE_LETTER/Splunk_Path` for rsync to work.

## :Copy Subroutine

---

- This subroutine does a rsync from window to linux. Nothing special.

## :CopyRandom Subroutine

---

- This `subroutine` uses logic to `randomize bucket ID's` between two Global variables that are set in `MaxVal` and `MinVal`.
- Used to prevent `bucket ID collisioning`.
- Logic does the bucket id setting before the copy happens via `rsync`
