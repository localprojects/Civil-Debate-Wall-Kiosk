#! /bin/bash
echo Starting Civil Debate Wall local web server...

export WORKON_HOME=~/Envs
source /usr/local/bin/virtualenvwrapper.sh

cd /Users/Mika/Code/CivilDebateWallServer
workon cdw
python main.py
