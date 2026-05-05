I wrote a script that checks if Docker is active or not, warns if disk usage is > 80% and logs everything to health.log file.

I have turned it into a cron job which runs every minutes as:

* * * * * /path/to/health_check.sh >> /path/to/health.log 2>&1

It means run this script every minutes, redirect output to health.log file and also redirect input to stderr to stdout i.e. health.log file. 