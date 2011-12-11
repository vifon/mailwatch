#!/usr/bin/env perl

use warnings;
use strict;
use 5.010;

if (-e "/tmp/mailwatch") {
    die "An another instance is running\n";
}

system("mkfifo /tmp/mailwatch");

my $pid = fork;
defined($pid) or die "unable to fork: $!\n";
if ($pid == 0) {
    exec("inotifywait -e moved_to -e create -m -r --exclude '.*\.swp.{0,1}' -o /tmp/mailwatch ~/mail") or die "unable to exec: $!\n";
}

sub cleanup {
    unlink "/tmp/mailwatch" if -e "/tmp/mailwatch";
    kill "TERM", $pid;
    exit(0);
}

$SIG{INT}   = \&cleanup;
$SIG{TERM}  = \&cleanup;
$SIG{HUP}   = \&cleanup;
$SIG{ABRT}  = \&cleanup;


open(my $events, '<', "/tmp/mailwatch") or die;
while (<$events>) {
    if (/^[^ ]*new/) {
        open(my $wmii, '|-', "wmiir create /rbar/1mail");
        print $wmii "colors #000000 #68ff05 #333333\nlabel MAIL\n";
        close $wmii;
    }
}
