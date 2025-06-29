general bash scripts

# TODO - connect to nas script
# TODO - basic script for linux installations

## git/gi.sh automates git add, commit, & push
-- USE: gi -m <commit message>
if -m not specified it will prompt for commit msg

## bkp/bkp.sh backs up home dir & select /etc files to bkp dir in nas
### TODO - cleanup script for bkp dir
-- RUN: ~/scripts/bkp/bkp.sh
-- setup in cron for 4am and 6pm
