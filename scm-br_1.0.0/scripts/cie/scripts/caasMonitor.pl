#!/usr/bin/perl
use WWW::Mechanize;
my $logFile = '/opt/crowd/play/play.log';
my $user = 'dev_admin';
my $pass = 'dev_admin';
my $server = 'app01dev.dev.canoe-ventures.com';
my $port = '8080';
my $url = "http://$server:$port/Canoe/login/auth";
my $mech = WWW::Mechanize->new();
my $response = $mech->get($url);
$mech->text() =~ /CAAS build ([A-Z0-9._]*)/;
print "Found: " . $1 . "\n";
my $time = localtime();
$response = $mech->submit_form(
        id => 'loginForm',
        fields    => { j_username => $user, j_password => $pass}
    );
print $mech->text();
exit 0;
if($mech->text() =~ /$properName/){
        $mech->follow_link( text_regex => qr/Log Out/ );
	doLog("OK - Server check at $time");
        exit 1;
}else{
	doLog("Error - Server check at $time. Restarting.\n");
        system("/opt/crowd/monitoring/crowdd restart >> $logFile");
        exit -1;
}

sub doLog {
   (my $msg) = @_;
   open(LOG,">>$logFile") || die $!;
   print LOG $msg . "\n";
   close(LOG);
}

