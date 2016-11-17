#!/usr/bin/perl
use strict;
my($tarball) = shift(@ARGV);

## Flags
# Turns jar md5sum validation off, it's on by default
my $force = 0;
# Turns backup off
my $backup = 1;
# Start apps
my $start = 0;

foreach (@ARGV){
  if(/restart/i){
    restart();
    exit 0;
  }
}
if(! -e $tarball){
  usage();
}

foreach my $arg (@ARGV){
  if($arg =~ /novalidate/){
    $force = 1;
  }
  if($arg =~ /nobackup/){
    $backup = 0;
  }
  if($arg =~ /start/){
    $start = 1;
  }
}

if(!$ENV{'JBOSS_HOME'} || !$ENV{'BATCH_HOME'}){
   print "Missing environmental variables:\n";
   print "Please set JBOSS_HOME: $ENV{'JBOSS_HOME'}\n";
   print "Please set BATCH_HOME : $ENV{'BATCH_HOME'}\n";
   exit -1;
}elsif(! -e $ENV{'JBOSS_HOME'}){
  print "Please install JBoss.\n";
}elsif(! -e $ENV{'BATCH_HOME'}){
  system("mkdir","-p","$ENV{'BATCH_HOME'}");
}

validate();

my $rel = $tarball;
chomp($rel);
$rel =~ s/\.tar\.gz//;
my $timestamp = `date +%m-%d.%H.%M`;
chomp($timestamp);
my $tmpDirectory = "/var/tmp/$timestamp";
mkdir "$tmpDirectory";
my $backupDirectory = $ENV{'HOME'} . "/backups/$timestamp";
system('tar','-xzf',"$tarball",'-C',"$tmpDirectory");

stopApps();

if($backup){
  backup();
}

deploy();

if($start){
   print "Starting applications...";
   startBatch();
   startJBoss();
}else{
   print "Please start JBOSS and batch processing.\n";
}
exit 0;

sub usage {
  print "$0 CAAS_archive [restart, start, novalidate, nobackup]\n";
  exit 0;
}
sub deploy {
  chdir("$ENV{BATCH_HOME}");
  system("jar","-xf","$tmpDirectory/$rel/smsi-1.0.zip");
  system("chmod","+x","$ENV{BATCH_HOME}/smsi.sh");
  chdir("$ENV{JBOSS_HOME}");
  system("jar","-xf","$tmpDirectory/$rel/caas.jar");
  chdir("$ENV{'JBOSS_HOME'}/server/default/deploy");
  if(`md5sum -c Canoe.war.md5` !~ /OK/){
     print "Deployment aborted, corruption: Canoe.war\n";
     exit -1;
  }
  if(`md5sum -c caasws.war.md5` !~ /OK/){
     print "Deployment aborted, corruption: caasws.war\n";
     exit -1;
  }
  unlink("Canoe.war.md5");
  unlink("caasws.war.md5");
  chdir("$ENV{'HOME'}");
  print "Release $rel has been deployed.\n";
}

sub compare {
  my($file1,$file2) = @_;
  foreach my $ret(`diff -q "$file1" "$file2"`){
    print $ret . "\n";
  }
}

sub backup {
  print "Backing up application files.\n";
  my @folders = ('caas','batch');
  foreach (@folders){
    system('mkdir','-p',"$backupDirectory/$_");
  }
  foreach my $x (`jar -tf "$tmpDirectory/$rel/caas.jar"`){
    chomp($x);
    if(-f "$ENV{'JBOSS_HOME'}/$x"){
      my(@tokens) = split(/\//,$x);
      system("cp","$ENV{'JBOSS_HOME'}/$x","$backupDirectory/caas/$tokens[-1]");
    }
  }
  foreach my $x(`unzip -l "$tmpDirectory/$rel/smsi-1.0.zip"`){
    chomp($x);
    if($x =~ /--/){next};
    my(@tokens) = split(/ +/,$x);
    if(-f "$ENV{'BATCH_HOME'}/$tokens[4]"){
      system("cp","$ENV{'BATCH_HOME'}/$tokens[4]","$backupDirectory/batch/$tokens[4]");
    }
  }
  print "CAAS portal, web services and batch have been backed up.\n";
}

sub validate {
  my %hash = ();
  my @errors = ();
  while(<DATA>){
    chomp($_);
    my($sum,$file) = split(/ +/);
    $hash{$sum} = $file;
  }
  foreach my $file (`find $ENV{'JBOSS_HOME'} -name "*.jar" | grep -v "\/tmp\/"`){
    my $chksum = `md5sum $file`;
    chomp($chksum);
    my($sum,$file) = split(/ +/,$chksum);
    if(!exists $hash{$sum}){
      push(@errors,$file);
    }
  }
  if(@errors){
    print "Please address the following library inconsistencies...\n";
    foreach (@errors){
      print $_ . "\n";
    }
    exit -1 unless $force;
  }else{
    print "JBoss libraries satisfied validation.\n";
  }
}

sub stopJBoss {
   my $host = `hostname`;
   chomp $host;
   chdir("$ENV{JBOSS_HOME}/bin");
   my $shutdownCmd = "./shutdown.sh -u admin -p admin -S -s $host";
   system("./shutdown.sh","-u","admin","-p","admin","-S","-s","$host");
   chdir("$ENV{HOME}");
   open(TAIL,"tail -f \"$ENV{JBOSS_HOME}/server/default/log/server.log\"|") || die "Could not open log file.$!";
   while(<TAIL>){
      my $line = $_;
      if ($line =~ /org.jboss.system.server.Server\] Shutdown complete/i){
         print "$line";
         system("rm","-f","$ENV{JBOSS_HOME}/server/default/log/*");
         return;
      }
   }
}
sub startJBoss {
   chdir("$ENV{JBOSS_HOME}/bin");
   system("./run-jboss.sh");
   chdir("$ENV{HOME}");
   sleep 10;
   my $results = 1;
   open(TAIL,"tail -f \"$ENV{JBOSS_HOME}/server/default/log/server.log\"|") || die "Could not open log file.$!";
   while(<TAIL>){
      my $line = $_;
      if ($line =~ /SVNTag=JBoss_4_2_3_GA date=200807181439\)\] Started/){
         print "$line";
         return $results;
      }
      if($line =~ /Exception/){
         print "$line";
      }
      if($line =~ /deployment failed/i){
         $results = 0;
         print "ERROR: $line";
      }
   }
}
sub stopBatch {
   chdir("$ENV{HOME}/batch");
   system("./smsi.sh","stop");
   chdir("$ENV{HOME}");
} 
sub startBatch {
   chdir("$ENV{HOME}/batch");
   my $ret = system("./smsi.sh","start");
   chdir("$ENV{HOME}");
   if($ret ne 0){
      print "Error: Batch startup.\n";
   }
}
sub stopApps {
  my(@procs) = `ps aux -U $ENV{USER} | grep java | grep -v grep`;
  if(@procs ne 0){
     stopJBoss();
     stopBatch();
     sleep 5;
     @procs = ();
     @procs = `ps aux -U jboss | grep java | grep -v grep`;
     foreach my $p (@procs){
        my(@toks) = split(/ +/,$p);
        print $toks[1] . " is still running. Forceably shutting down.\n";
        system("kill","-9","$toks[1]");       
    }
  }
}
sub restart {
  stopApps();
  my $ret = startJBoss();
  startBatch();
  print "Startup returning $ret\n";
  exit $ret;
}
__DATA__
00e0e70114ffa0cf2261eab9c9c00f52  jboss-4.2.3.GA/client/jboss-aop-jdk50-client.jar
029b13a9135926f9c3afdbe822bb6452  jboss-4.2.3.GA/server/default/lib/jboss-vfs.jar
04e26b9160c6dbafcf0479c64642b6e8  jboss-4.2.3.GA/server/all/lib/jboss-jaxws-ext.jar
05bc4633c5914f08573f6d8c13b0f86b  jboss-4.2.3.GA/server/default/lib/bsf.jar
0619f8725181c98ed642bc543491acb1  jboss-4.2.3.GA/server/all/deploy/jbossws.sar/xmlsec.jar
0755c2f7f28a313159429feeb8295775  jboss-4.2.3.GA/server/all/lib/mail-plugin.jar
077cae62f07a224f1fffc6df57d792fc  jboss-4.2.3.GA/server/all/lib/commons-httpclient.jar
08738b954554c201c0e0dc3a05d7718a  jboss-4.2.3.GA/client/getopt.jar
09025e19c55d780455d26bf5bb247ef9  jboss-4.2.3.GA/server/all/lib/jboss-management.jar
096d08b75ca5a425187dedb68442d8ec  jboss-4.2.3.GA/server/default/lib/autonumber-plugin.jar
0a4c187d61d8321f63e596184673787e  jboss-4.2.3.GA/server/all/lib/commons-logging.jar
0a98f81910d5632ce497da7db27bf4c0  jboss-4.2.3.GA/server/all/lib/bsh-deployer.jar
0b91454b557d87c445084e8ad52c9192  jboss-4.2.3.GA/server/all/lib/jaxen.jar
0c7e857006f4d193726648ff56de1b6f  jboss-4.2.3.GA/server/default/deploy/jboss-web.deployer/jbossweb-extras.jar
0e265ee23f38cedd6226817ccc1159ae  jboss-4.2.3.GA/server/default/lib/jboss-iiop.jar
0e73b6c15e31a02633268146e4367aab  jboss-4.2.3.GA/server/all/deploy/jboss-aop-jdk50.deployer/jboss-aspect-library-jdk50.jar
0ef11be9f3222fe96a70f62045eb7625  jboss-4.2.3.GA/server/all/lib/hsqldb-plugin.jar
0f65ccafd92b7a8c649a4164c6b6a8bf  jboss-4.2.3.GA/server/default/lib/commons-logging.jar
0fb4f209dba3864ad1e8cbc59385819a  jboss-4.2.3.GA/client/jboss-annotations-ejb3.jar
10cad7274ad3a5dd91cd9863972192ad  jboss-4.2.3.GA/server/all/lib/jnpserver.jar
10f8ee6b472422bc36d24aa4210a0701  jboss-4.2.3.GA/server/all/lib/jacorb.jar
124f94e882dddd2b14ac787ebd934cfb  jboss-4.2.3.GA/server/default/deploy/management/console-mgr.sar/web-console.war/images/otherimages.jar
1424fd813bdb11d30f0a28a6ed973677  jboss-4.2.3.GA/server/all/lib/ejb3-persistence.jar
156ca98cd57319614d7b109cb09dc558  jboss-4.2.3.GA/server/all/lib/avalon-framework.jar
162bca122e5392ceb55d825f45e9af5f  jboss-4.2.3.GA/server/default/lib/bsh-deployer.jar
169d7bbf7f90bfbadd962faf44fdf3c9  jboss-4.2.3.GA/server/all/lib/commons-collections.jar
18b89d360377b137c117e421a7470927  jboss-4.2.3.GA/server/default/lib/el-api.jar
195dd005b126f0a49d4bed60ba412d05  jboss-4.2.3.GA/server/all/deploy/management/console-mgr.sar/console-mgr-classes.jar
1c79ec3eb25994174554978300c6355d  jboss-4.2.3.GA/lib/commons-httpclient.jar
1ec9e9022f58a10e42676c7a97977df2  jboss-4.2.3.GA/server/default/deploy/ejb3.deployer/jboss-annotations-ejb3.jar
1f7c9bd14bbd10ba9bb1ccdf96e9d1a9  jboss-4.2.3.GA/server/all/lib/dom4j.jar
20f2ff4f1b81c69f78d81c89753ae97c  jboss-4.2.3.GA/server/default/lib/jbossjta.jar
20fde9019ac27256b862d6a8b0435163  jboss-4.2.3.GA/server/default/lib/jbossts-common.jar
21581d082855c411eaea315fb8d145e1  jboss-4.2.3.GA/server/all/deploy/jboss-aop-jdk50.deployer/jboss-aop-jdk50.jar
219e4c6f2ba5d066fedfd78697847054  jboss-4.2.3.GA/server/default/lib/ojdbc14.jar
21cd8255e9ba20199fc30c69ddaba27b  jboss-4.2.3.GA/client/policy.jar
22f9ee4afc0de126b83c866c507477c6  jboss-4.2.3.GA/server/default/lib/xmlentitymgr.jar
259a1b042613ba32c1799da9f782157c  jboss-4.2.3.GA/server/all/deploy/jboss-web.deployer/jsf-libs/jboss-faces.jar
25aae3d9b3c4cdd06abfbcae6c5a28ba  jboss-4.2.3.GA/server/all/deploy/jboss-aop-jdk50.deployer/trove.jar
262e24235a1458451dcc8108805dd5ca  jboss-4.2.3.GA/client/jboss-ejb3x.jar
26ba0b648ac8641fdc66943b2bb65a4e  jboss-4.2.3.GA/client/jbossws-client.jar
27873d655694f82d52fb4cfedcd28ab3  jboss-4.2.3.GA/server/all/lib/autonumber-plugin.jar
27c67d9757fdf5d82bdf479d5618efc6  jboss-4.2.3.GA/server/default/lib/jmx-adaptor-plugin.jar
2a1a64969ab274468f624fe2cefa9e48  jboss-4.2.3.GA/server/default/lib/jsp-api.jar
2a6f1285d4738921628d6f4b09f6d39c  jboss-4.2.3.GA/server/all/lib/jboss-jaxrpc.jar
2b307654348940370b9d7e7d0deab9dd  jboss-4.2.3.GA/server/default/deploy/jbossws.sar/jbossws-core.jar
2b30c5dceb93217689b6b5ae06970db5  jboss-4.2.3.GA/server/default/lib/jbossws-common.jar
2bc3a3354eb05ed5a6874b56ad49ac6c  jboss-4.2.3.GA/server/default/lib/jboss-ejb3x.jar
2c2710ae48a2bba2bca92cc1bcac6f3d  jboss-4.2.3.GA/client/jboss-xml-binding.jar
2daa986eab72b85e5abbd26b5b02547f  jboss-4.2.3.GA/server/default/lib/jboss-remoting-int.jar
2f194d9b6737cc841051162696716829  jboss-4.2.3.GA/server/default/lib/jboss-srp.jar
2f3364320fba0e7a9fe84a2e87a840bd  jboss-4.2.3.GA/client/jboss-common-client.jar
2f6839e2f0927db6335408aff8dadc55  jboss-4.2.3.GA/server/all/deploy/jboss-web.deployer/jasper-jdt.jar
30fb7ff50e3a50b297bf107869097136  jboss-4.2.3.GA/server/default/lib/cglib.jar
31d720d4b88071332c53847348578c52  jboss-4.2.3.GA/bin/twiddle.jar
3258e042d3ea3d1d1db2c5e4b051d89c  jboss-4.2.3.GA/server/all/lib/jbossws-spi.jar
33119d960041cd8953e74a808a80c37d  jboss-4.2.3.GA/server/default/deploy/jbossws.sar/wstx.jar
33166c919b6515b10137a1bd95dc1852  jboss-4.2.3.GA/server/default/lib/jboss-management.jar
33863b340d02966cbc0e1aa8ea0c2964  jboss-4.2.3.GA/server/default/lib/jboss-jsr88.jar
33f37b8e5e5564caaeb57f22f2f793e1  jboss-4.2.3.GA/client/ejb3-persistence.jar
38788521b9454d1e9ab8bc00a90d47b8  jboss-4.2.3.GA/server/all/deploy/jboss-web.deployer/jsf-libs/jsf-api.jar
39872e667243c901e2f6dbafc98626b4  jboss-4.2.3.GA/bin/run.jar
3a8eb8c96735cb0411626b5f2e38b9ee  jboss-4.2.3.GA/server/default/deploy/jboss-web.deployer/jsf-libs/jsf-impl.jar
3b9ec3b17658edb90d229c5db5ac2a02  jboss-4.2.3.GA/server/default/lib/mail-plugin.jar
3c12136d3c2e0cc05210beecdd6a0830  jboss-4.2.3.GA/client/jboss-jsr77-client.jar
3d1a255ec7a2d784bb114cd7dd9d6599  jboss-4.2.3.GA/client/jbosscx-client.jar
3e059466041599e65d1c6fe1e434341c  jboss-4.2.3.GA/server/default/lib/properties-plugin.jar
3e79e86bb138554c4b8e346cf7b7a6d4  jboss-4.2.3.GA/server/default/lib/scheduler-plugin.jar
3f783783407b058c355082a8eac4944d  jboss-4.2.3.GA/server/default/lib/jboss-j2ee.jar
40d960c3f56ed13f051eb5197e092b3c  jboss-4.2.3.GA/server/default/lib/antlr.jar
43788fb1445c210f1da73436935d01fa  jboss-4.2.3.GA/server/all/lib/bsh.jar
43cac82bcd1e83f070618275356d5279  jboss-4.2.3.GA/server/all/lib/el-api.jar
43eefbfba2e188b6b900dc211d70bfbe  jboss-4.2.3.GA/server/all/lib/bcel.jar
44e541bf536126e164807378ec2c7713  jboss-4.2.3.GA/client/jboss-srp-client.jar
44f3681c4a40977cdec7f236fe5319a1  jboss-4.2.3.GA/client/jmx-client.jar
467268fb620de030f479c751a4bdfdc2  jboss-4.2.3.GA/server/default/deploy/jboss-bean.deployer/jboss-bean-deployer.jar
46ac09c34484102862cba06657e7d1ed  jboss-4.2.3.GA/client/jboss-iiop-client.jar
49209b88a589fd09ea9c953a70908255  jboss-4.2.3.GA/server/all/lib/jbosssx.jar
4a302452349c765dd27c0a32923a47d7  jboss-4.2.3.GA/server/default/lib/log4j.jar
4ba79469ff1606706a8128d6d50c1499  jboss-4.2.3.GA/bin/shutdown.jar
4c7a944f64fa22bf7e94a1cbe9f5f2fb  jboss-4.2.3.GA/lib/endorsed/jboss-jaxrpc.jar
4cd129d003dab74efef6c28475e7907e  jboss-4.2.3.GA/server/all/deploy/jboss-web.deployer/jbossweb-service.jar
4dfbe55ce2cb4f6c460665ccd44cb85d  jboss-4.2.3.GA/server/all/deploy/jbossws.sar/jettison.jar
4e44f7c035ba1e362768ba6b06840ac5  jboss-4.2.3.GA/server/all/lib/activation.jar
4e5061b4356fbab47656dfb87e300c31  jboss-4.2.3.GA/server/default/deploy/jbossws.sar/jaxb-impl.jar
4eda8362c5428d5867de02b356984144  jboss-4.2.3.GA/lib/endorsed/xalan.jar
4ee3c6714ccb66d2fa740989a0c84f2d  jboss-4.2.3.GA/client/jbossws-framework.jar
4f1da09db3af44bd13126d28181cb1df  jboss-4.2.3.GA/server/default/lib/jboss-remoting.jar
4ff363915a1ccb2f06481818dbcfcbea  jboss-4.2.3.GA/client/concurrent.jar
502a0342bdacf054aca80a0fbcd7a5e8  jboss-4.2.3.GA/client/jboss-deployment.jar
50a50e454777f1b41cc65c167f9681a4  jboss-4.2.3.GA/client/scout.jar
51afd9cc45b70ce9ec5e70cdb851e2af  jboss-4.2.3.GA/server/default/lib/jboss.jar
53042da435129c09762cd2f12be92bdf  jboss-4.2.3.GA/lib/concurrent.jar
54077dee8eee49f8329427f782362a3c  jboss-4.2.3.GA/lib/commons-logging.jar
5481bfbee3d2d41c3e39d13b195333ad  jboss-4.2.3.GA/server/all/deploy/juddi-service.sar/juddi-saaj.jar
548dc30b5940b14f827af6aaa9ee8aab  jboss-4.2.3.GA/server/default/lib/jbossmq.jar
549b64d339cfdc83c90fec1af5e64a64  jboss-4.2.3.GA/server/all/lib/jboss-j2ee.jar
55b49b02d8a36ca775c83bb11c18a95d  jboss-4.2.3.GA/server/all/lib/bindingservice-plugin.jar
56d174b01c453938cd36ae366149629e  jboss-4.2.3.GA/server/default/lib/scheduler-plugin-example.jar
572a6a4ab677dc90cc21c76cf9a0139c  jboss-4.2.3.GA/server/all/lib/jboss-ejb3x.jar
5748b9d9ec9333e072937179127881f1  jboss-4.2.3.GA/server/all/lib/xmlentitymgr.jar
58caa6a7ff5f70dd66949631197e79f5  jboss-4.2.3.GA/server/default/lib/jboss-common-jdbc-wrapper.jar
5c688847cf4eb9990e701580e483c2fe  jboss-4.2.3.GA/lib/endorsed/jboss-jaxws-ext.jar
5e1142f9a69bb8b32ff7cc6c1be24d0f  jboss-4.2.3.GA/server/all/deploy/jbossws.sar/FastInfoset.jar
5fcba6cd6192d9d4e3c1cafac344f618  jboss-4.2.3.GA/server/all/deploy/jboss-aop-jdk50.deployer/pluggable-instrumentor.jar
61827f03dacfa95bb5a3ebd754454434  jboss-4.2.3.GA/server/all/lib/javassist.jar
62446a964e9a7228df0a966e356a539e  jboss-4.2.3.GA/server/all/lib/jbossts-common.jar
6398d6d9100e2de2e6699b5117a99e13  jboss-4.2.3.GA/server/all/lib/jsp-api.jar
63b46c53229b60d7966c820644b4c5bb  jboss-4.2.3.GA/server/default/deploy/jbossws.sar/policy.jar
6408f82f2d0f72396947ba50b6d0e0fd  jboss-4.2.3.GA/server/minimal/lib/jboss-minimal.jar
657d163054d29604f6afc8033a95019d  jboss-4.2.3.GA/server/all/lib/hsqldb.jar
65daf9b2fb08c8fd724b2668e32f06cf  jboss-4.2.3.GA/server/all/deploy/management/console-mgr.sar/web-console.war/images/otherimages.jar
66ac9b80c2eaf9c7065fe89d47726c87  jboss-4.2.3.GA/client/log4j.jar
677972ad0a5e30a4266a5fa408f9ce5f  jboss-4.2.3.GA/client/jboss-transaction-client.jar
69027edcb7e76db72a3381eb400baf27  jboss-4.2.3.GA/server/default/deploy/jboss-bean.deployer/jboss-container.jar
69bba7cc2c8108e3fa68e96b29558482  jboss-4.2.3.GA/server/default/deploy/jbossws.sar/FastInfoset.jar
6bb6204ada9d674a8d7d29ab73d7c894  jboss-4.2.3.GA/lib/jaxb-api.jar
6c167731731e14028caa63aaf41817aa  jboss-4.2.3.GA/server/all/lib/jbossjta.jar
6d180521f380692e9882a77bcc998a6e  jboss-4.2.3.GA/server/all/lib/quartz.jar
6d928c0a5346d40a9788313e1a79bc3e  jboss-4.2.3.GA/server/all/deploy/jbossws.sar/jaxb-impl.jar
706e2290a9a064eb524987b4e3fe9eb0  jboss-4.2.3.GA/server/default/lib/bcel.jar
70d7fac9e1c84bf8eea9ed050df2d3be  jboss-4.2.3.GA/server/default/lib/jboss-serialization.jar
70f0918f58f1946acb780faf08bc57d3  jboss-4.2.3.GA/server/all/lib/jboss-jaxws.jar
716691ee3775ea20c1051a5cbe084a16  jboss-4.2.3.GA/server/default/lib/jbosssx.jar
72aacb2ec16af10b3d80999e9fd1c5fe  jboss-4.2.3.GA/server/default/lib/quartz.jar
73762ab5c4140cd9389e790178acbf73  jboss-4.2.3.GA/server/all/lib/hibernate-annotations.jar
73cacd318d18c7c9a37ac6b1cac70404  jboss-4.2.3.GA/server/all/deploy/jboss-web.deployer/jstl.jar
7417b1798c504d074ec5a2dfede40f50  jboss-4.2.3.GA/client/jaxb-impl.jar
7508e194040142445df25bed22c38cf1  jboss-4.2.3.GA/client/jaxb-xjc.jar
755690dd8d8a96235b136dc123553943  jboss-4.2.3.GA/client/commons-logging.jar
7561ca88f4cf71aa82de037980959c1a  jboss-4.2.3.GA/client/antlr.jar
75a586e0bb2dfddb143e7c6e14820dc3  jboss-4.2.3.GA/server/all/deploy/management/console-mgr.sar/web-console.war/applet.jar
75b7b86899c72622007fb1b5bffa1dc8  jboss-4.2.3.GA/client/jbossws-jboss42.jar
76db16e13dba81d5208eca4ac10c8b9e  jboss-4.2.3.GA/lib/getopt.jar
770031a0697662ea3e1e251ece17bd65  jboss-4.2.3.GA/server/minimal/lib/jnpserver.jar
78f737a09f9838d12650dcb6a2dc9790  jboss-4.2.3.GA/server/default/lib/jboss-transaction.jar
7923781e020fff51ed6c6ccf1271d054  jboss-4.2.3.GA/server/default/lib/hsqldb.jar
7a174a6c0da1310e4a618ab9bc6a8de8  jboss-4.2.3.GA/server/default/deploy/management/console-mgr.sar/jcommon.jar
7ad2f08c4dea42ff2f659522bbee5110  jboss-4.2.3.GA/server/all/lib/jboss-remoting.jar
7ca0f56c92f29c14806d293f6007e32b  jboss-4.2.3.GA/server/all/deploy/jboss-bean.deployer/jboss-dependency.jar
7cb1fcc14836564c7fa15434084dcb3e  jboss-4.2.3.GA/server/default/deploy/management/console-mgr.sar/console-mgr-classes.jar
7ebd9f907acb3a284f0c7c9bd7000f63  jboss-4.2.3.GA/server/all/lib/scheduler-plugin.jar
7f424553993f37d8f9373d28cbbb0a48  jboss-4.2.3.GA/server/default/lib/jaxen.jar
7f8f17e1c43b500476c98338607caabb  jboss-4.2.3.GA/client/hibernate-annotations.jar
806eba6c7c5951f1de07e23a1bb23487  jboss-4.2.3.GA/lib/jboss-jmx.jar
80a0d1ec0ea468ac744ce9ea078e5e01  jboss-4.2.3.GA/lib/endorsed/jaxb-api.jar
80dde12aba80df270bd8bfd9b7523734  jboss-4.2.3.GA/server/all/lib/bsf.jar
823cb5d6a51a15bf4d3a0b2f5a6fbc1e  jboss-4.2.3.GA/server/all/deploy/juddi-service.sar/juddi-service.jar
8429faed845b4c3c913b4771efbdc524  jboss-4.2.3.GA/server/default/deploy/jboss-aop-jdk50.deployer/trove.jar
842d96d025209240cab3165e5e99dcd7  jboss-4.2.3.GA/client/stax-api.jar
84707f0764fa17379ecf4158a592c060  jboss-4.2.3.GA/client/jbossws-spi.jar
86579294030e7ada95918f4c77bd33c5  jboss-4.2.3.GA/client/jbossall-client.jar
86f4afccad1cbddac2d14da6cca592cb  jboss-4.2.3.GA/server/default/deploy/jbossws.sar/wsdl4j.jar
889d7fa71cad75e612aa79150cae84d4  jboss-4.2.3.GA/client/jboss-client.jar
890a5f7ff478d278320664659b10b089  jboss-4.2.3.GA/server/default/deploy/jboss-web.deployer/jbossweb-service.jar
896734ee5b3a73716b2d20722f2ae6f7  jboss-4.2.3.GA/server/all/deploy/jbossws.sar/jboss-jaxb-intros.jar
8a6a298aa04cda19fe4963361e8eb323  jboss-4.2.3.GA/client/stax-ex.jar
8b4138b75b7be9fcc26f8d6ebf8f31cb  jboss-4.2.3.GA/server/all/deploy/jboss-aop-jdk50.deployer/jrockit-pluggable-instrumentor.jar
8c024cbc513a2151b86c799f096b3762  jboss-4.2.3.GA/server/default/deploy/jbossws.sar/jboss-jaxb-intros.jar
8c62fd8d0c81c47b0f2b013288a29ac5  jboss-4.2.3.GA/server/all/lib/jmx-adaptor-plugin.jar
8cd7fb2a4a6c92a43f2abb39db0c0a1e  jboss-4.2.3.GA/server/all/deploy/jbossws.sar/wsdl4j.jar
8d50516f402e80499dac3f56bba3db77  jboss-4.2.3.GA/server/default/lib/mail.jar
8d5f2982dcfb6ea6d3c8d3aadc941c36  jboss-4.2.3.GA/server/all/lib/scheduler-plugin-example.jar
8d9464106bb1cedfea1af28df4031904  jboss-4.2.3.GA/server/all/lib/jboss-remoting-int.jar
8e2a732d9aef5b7b6bde8853cf459305  jboss-4.2.3.GA/server/default/deploy/jbossws.sar/jettison.jar
8ffc6345251737dfcb9fd09da6c71685  jboss-4.2.3.GA/server/default/deploy/jboss-bean.deployer/jboss-dependency.jar
90e9cbe94fb39574f5de3197c43facdb  jboss-4.2.3.GA/server/default/lib/ejb3-persistence.jar
9132a9838a2b7452f931d6037cd5acc7  jboss-4.2.3.GA/client/jboss-serialization.jar
91ea033a3daaad90f5509b61a4b538ec  jboss-4.2.3.GA/client/jaxb-api.jar
946409a91363888069cf4bed26794e0e  jboss-4.2.3.GA/server/default/deploy/jboss-web.deployer/jstl.jar
94d36a368f2a4e62009762c154831fa0  jboss-4.2.3.GA/server/all/lib/mail.jar
94ec4068979ac9966f5b532f1e63ea43  jboss-4.2.3.GA/server/all/lib/jgroups.jar
952c1809783c9d128eded074019c0a78  jboss-4.2.3.GA/docs/examples/varia/derby-plugin.jar
967735c90ebc3b0b6e7914f94878a830  jboss-4.2.3.GA/server/all/deploy/snmp-adaptor.sar/snmp-adaptor.jar
992f2e4fa87270ab37cb3b1dd12bc0d8  jboss-4.2.3.GA/client/jnp-client.jar
9c33bf50564347bf39b42c2c7e4f7bd6  jboss-4.2.3.GA/server/default/lib/jboss-jaxrpc.jar
9c85af7a05a265950466d75eb65aa9ce  jboss-4.2.3.GA/server/all/lib/jboss-vfs.jar
9cbad08bf12a7fdafd6e2dab74d1ea56  jboss-4.2.3.GA/server/default/lib/javassist.jar
9de41031c083de8d6d0894dfdbf399dd  jboss-4.2.3.GA/server/all/deploy/management/console-mgr.sar/jfreechart.jar
9e58de37e905188d79d48f43e1cfca73  jboss-4.2.3.GA/server/all/deploy/jboss-web.deployer/jbossweb.jar
9e984e01414de301b2709eb7939e5cfa  jboss-4.2.3.GA/client/commons-codec.jar
a07b927ba70ef751f704797165d7cd41  jboss-4.2.3.GA/server/all/deploy/jbossws.sar/jaxb-api.jar
a08afe5824fd2dc15242e627476e1220  jboss-4.2.3.GA/server/all/deploy/jboss-web.deployer/jbossweb-extras.jar
a1ede77d3f7b34ff89b33c89a957b030  jboss-4.2.3.GA/server/default/lib/bsh.jar
a3329e9dd3e5e74401c760a3b57d74d7  jboss-4.2.3.GA/server/default/lib/bindingservice-plugin.jar
a459f8ccc03c412a4ed8dce8ca3aa513  jboss-4.2.3.GA/client/jbossws-common.jar
a486baf4b01401925b73144b9dfb1074  jboss-4.2.3.GA/server/all/lib/jboss-transaction.jar
a720baa5f40e528aa5aff15d7aa71a49  jboss-4.2.3.GA/server/all/lib/log4j-snmp-appender.jar
a722dccae70ef27c95cade438c47704b  jboss-4.2.3.GA/lib/log4j-boot.jar
a79870dec4acab60b08ca98242b7b101  jboss-4.2.3.GA/server/default/lib/jboss-jaxws.jar
a7c0b5d5c22af6c17383ca7f5f2d7105  jboss-4.2.3.GA/docs/examples/jmx/logging-monitor/lib/logging-monitor.jar
a87333b3a2f600c1a99ddc206322cc5a  jboss-4.2.3.GA/client/jboss-system-client.jar
a94b2899fb8da12a53d07dd16f5595f3  jboss-4.2.3.GA/server/default/deploy/jboss-bean.deployer/jboss-microcontainer.jar
aa53c8803bb6a5291960d64e548f46ea  jboss-4.2.3.GA/server/all/lib/hibernate3.jar
ab5c44e87620610b7538df0002fd30b9  jboss-4.2.3.GA/lib/jboss-xml-binding.jar
abe2d173ee59ca954bfdbd55d8611b72  jboss-4.2.3.GA/server/default/lib/jbossjta-integration.jar
abfd4736e391bc318ce555b5d7721761  jboss-4.2.3.GA/lib/endorsed/xercesImpl.jar
acbefdb04119a422fe9f420e82829920  jboss-4.2.3.GA/client/jboss-jaxrpc.jar
ad1a01222e6d116651792a8e78c5f100  jboss-4.2.3.GA/client/streambuffer.jar
ad249cdc3e3fac2bd3f7fdb68cafad6d  jboss-4.2.3.GA/client/avalon-framework.jar
adf9517ab2702f21cfeef7533b06f0a9  jboss-4.2.3.GA/client/jmx-invoker-adaptor-client.jar
af3776f1b55860869d4cc1f1c2b5f574  jboss-4.2.3.GA/server/default/deploy/jboss-aop-jdk50.deployer/jboss-aop-jdk50.jar
af9d4747d699427e551a915bee27bd56  jboss-4.2.3.GA/server/default/lib/jboss-jca.jar
afbac359cdcea03fb3b4a51a96516ce4  jboss-4.2.3.GA/server/all/deploy/jboss-web.deployer/jsf-libs/jsf-impl.jar
b15775e521bf8c0762e4d9c3f1faa380  jboss-4.2.3.GA/server/all/lib/jboss-cache-jdk50.jar
b363bdde4cd08a62cb5a1a764dd5e8b3  jboss-4.2.3.GA/client/jbossha-client.jar
b37384601e6e775d1bfd5b3385c82edc  jboss-4.2.3.GA/server/default/lib/jboss-monitoring.jar
b39b526fca62d6e03ce70af181b43472  jboss-4.2.3.GA/server/default/lib/commons-codec.jar
b513c0518aa0f42996a371130de5e62a  jboss-4.2.3.GA/server/default/lib/jbossws-spi.jar
b5ae05be9ec8654cc0605f65cc77c525  jboss-4.2.3.GA/server/default/lib/jbossws-jboss42.jar
b5e5670bf3b56bbba6a2898ea393848e  jboss-4.2.3.GA/client/trove.jar
b65ddf25b5c44d715be9caae444ce406  jboss-4.2.3.GA/client/jboss-saaj.jar
b826b47667e73358dfa3a0a267011555  jboss-4.2.3.GA/server/all/lib/cglib.jar
b8447286df16e87c336da2e792fb2d90  jboss-4.2.3.GA/server/all/deploy/jbossws.sar/jbossws-core.jar
b8adf291166d2794dceb95578a4b6f33  jboss-4.2.3.GA/server/default/lib/hibernate-validator-4.0.2.GA.jar
b8bb27963231a0d8c148586c1fa32594  jboss-4.2.3.GA/lib/jboss-common.jar
b945388768b42300691da5f34af9d032  jboss-4.2.3.GA/client/mail.jar
b9b86bb17beb1a0bcd23ca6a7e1395c4  jboss-4.2.3.GA/server/all/lib/jboss-srp.jar
b9ef81bd683c1c2bb7f34356058001a5  jboss-4.2.3.GA/server/minimal/lib/jboss-management.jar
ba2bd5d83b6d556214b087cbb0233e6f  jboss-4.2.3.GA/client/jaxws-rt.jar
baa47605bfa564c9aa1f630753c9be08  jboss-4.2.3.GA/server/default/lib/jnpserver.jar
bae662112afbd6bcc6d105049bea8719  jboss-4.2.3.GA/server/default/lib/joesnmp.jar
bbb2bf4149d0989f2e618566d74485b2  jboss-4.2.3.GA/server/default/deploy/jboss-aop-jdk50.deployer/jboss-aspect-library-jdk50.jar
bbc0092f4e03557dc627bbaa92ed7a02  jboss-4.2.3.GA/client/commons-httpclient.jar
bbd23547f87985b65d8a90b3b6666a45  jboss-4.2.3.GA/server/default/lib/commons-collections.jar
bbd2c07fd33813a416fedf2fb8fbc699  jboss-4.2.3.GA/client/jboss-aspect-jdk50-client.jar
bc02bb6db90c2954ae4b83f8d71004b3  jboss-4.2.3.GA/server/all/deploy/jboss-bean.deployer/jboss-container.jar
bcf3e312ebb4a907544111732bccb557  jboss-4.2.3.GA/server/all/lib/jbossws-jboss42.jar
bdbd32b31769808c31b31a3afa7c71d5  jboss-4.2.3.GA/client/activation.jar
bde5dc681d483cff2fccf352b9368280  jboss-4.2.3.GA/server/all/lib/jboss-jca.jar
be953549b43972fc42dfaf64ee66de7f  jboss-4.2.3.GA/server/all/lib/commons-codec.jar
c12cdccfc402e094539ca0b59de905e7  jboss-4.2.3.GA/docs/examples/jmx/ejb-management.jar
c14179ab469b347cdf90da84c5b0ae55  jboss-4.2.3.GA/server/default/lib/hsqldb-plugin.jar
c2272150cbf39c671197070646d002ba  jboss-4.2.3.GA/server/default/deploy/jboss-web.deployer/jsf-libs/jsf-api.jar
c2a1cad9663b898b72e6177c0f3bed3e  jboss-4.2.3.GA/server/default/lib/jboss-hibernate.jar
c35271bd289763fa128e591bd4c43f3a  jboss-4.2.3.GA/server/all/deploy/jbossws.sar/policy.jar
c38e8d9dabfd9478b1c916947faa43f0  jboss-4.2.3.GA/server/default/lib/jboss-jaxws-ext.jar
c4e3cf6b70ac031cfb0fe0f8c8089924  jboss-4.2.3.GA/server/all/lib/log4j.jar
c528a3a316e1b40a7936d4a708d77d3a  jboss-4.2.3.GA/client/jboss-j2ee.jar
c61c3bdf9ac4e2fa42bd760b348247b4  jboss-4.2.3.GA/server/all/lib/jboss.jar
c6466736afbec721de83c2d5ca19385d  jboss-4.2.3.GA/server/all/lib/jbossws-common.jar
c697fe04a0fa6d0717d426473025b9b9  jboss-4.2.3.GA/lib/endorsed/jboss-jaxws.jar
c71d4b5c159cdac4ef822ed11c142c99  jboss-4.2.3.GA/client/jbossjmx-ant.jar
c742bc1a1c04741888df1400c5cd9d14  jboss-4.2.3.GA/server/all/lib/jboss-jsr77.jar
c743c9ca43d3c47243bdcee6b62f0b32  jboss-4.2.3.GA/server/all/lib/jbossha.jar
c7a534dabef48373f71f500a0a8bd03f  jboss-4.2.3.GA/client/servlet-api.jar
c7d4d37ec7c91b736bcc8719dbfe623b  jboss-4.2.3.GA/lib/jaxb-impl.jar
c81aeb835c302f30f2534c4ed72004fc  jboss-4.2.3.GA/server/default/deploy/jboss-web.deployer/jbossweb.jar
c8226c278a7c091f47173ea32b59a498  jboss-4.2.3.GA/server/all/lib/properties-plugin.jar
c82c9ddfb5cb830dfaf96d1fad94c0a6  jboss-4.2.3.GA/server/all/deploy/ejb3.deployer/jboss-annotations-ejb3.jar
c863f35cfa1375878187cbe227d6c3c3  jboss-4.2.3.GA/server/all/lib/joesnmp.jar
c8e7ea55dc475e2f978f6147a13d5dcc  jboss-4.2.3.GA/client/jaxws-tools.jar
cd3f8277a1fec0c27266add39899969f  jboss-4.2.3.GA/server/default/lib/jboss-jsr77.jar
d06db8fd77802dae4c403f5e59b25b2b  jboss-4.2.3.GA/server/all/lib/hibernate-entitymanager.jar
d2b302d17aeedf1a2e79d2234ba7b931  jboss-4.2.3.GA/server/all/lib/jbossws-framework.jar
d4266e75d9e5f9dcf43576b7449c0264  jboss-4.2.3.GA/server/all/deploy/jbossws.sar/wstx.jar
d4edbb5e09dfe3496654abddc0d9fec4  jboss-4.2.3.GA/lib/commons-codec.jar
d4fff168dd64e467ae6123487b044e04  jboss-4.2.3.GA/client/logkit.jar
d530a352933c28bd0dda35b78d01abef  jboss-4.2.3.GA/lib/endorsed/serializer.jar
d559daeee49ee45e9539bc39b55673a7  jboss-4.2.3.GA/server/default/lib/jboss-saaj.jar
d5d3e0a001fc54cc06d69924121d5762  jboss-4.2.3.GA/server/default/deploy/jbossws.sar/stax-api.jar
d6336e1dd90c9fc6a5d947ab9df398a9  jboss-4.2.3.GA/server/all/lib/servlet-api.jar
d64aa74857887205f380dbc0f2ef607e  jboss-4.2.3.GA/server/all/deploy/juddi-service.sar/juddi.jar
d9d6cebf5248ea68b7ccdb6a0c455123  jboss-4.2.3.GA/server/all/lib/jbossjta-integration.jar
df2812f86c5fcf35a4e0996099cfb19d  jboss-4.2.3.GA/server/default/deploy/management/console-mgr.sar/jfreechart.jar
df668f05f1f7c7d2c6a2834fa9fdf11f  jboss-4.2.3.GA/server/all/lib/jboss-monitoring.jar
e153d2e1e8a76fcbcff793238a549b61  jboss-4.2.3.GA/client/jacorb.jar
e1686529afa8923051cfe1b72b95db4e  jboss-4.2.3.GA/server/all/deploy/ejb3.deployer/jboss-ejb3.jar
e5c85cff62ecc079ddf5355d67cf9cfc  jboss-4.2.3.GA/client/jettison.jar
e710c062bc0ac5bd0db6ead020d26746  jboss-4.2.3.GA/server/default/lib/log4j-snmp-appender.jar
e833038997923d3d552d5045cf97645e  jboss-4.2.3.GA/server/default/lib/dom4j.jar
e96e15d1add8fcb3e8efe0ec4075b28f  jboss-4.2.3.GA/server/all/deploy/jboss-bean.deployer/jboss-microcontainer.jar
e99c0037eacb0099496ce078c561385c  jboss-4.2.3.GA/lib/servlet-api.jar
e99c0037eacb0099496ce078c561385c  jboss-4.2.3.GA/server/default/lib/servlet-api.jar
e9ad159e6da370c4dc3e24aa600530f1  jboss-4.2.3.GA/server/all/deploy/juddi-service.sar/scout.jar
e9e6d349007d73943f83ea01efbb10fa  jboss-4.2.3.GA/server/all/lib/jboss-iiop.jar
ea859209f9920310a7319e0f22f46ac3  jboss-4.2.3.GA/server/all/lib/jboss-hibernate.jar
eb32797787e107d854aa106cfd03fd42  jboss-4.2.3.GA/client/jbossmq-client.jar
ebf3c4e33144ff8814a50f54d86052c0  jboss-4.2.3.GA/lib/endorsed/jboss-saaj.jar
ec2637919298179c6d5178ed0a7634ae  jboss-4.2.3.GA/server/default/deploy/management/console-mgr.sar/web-console.war/applet.jar
ed329ff646073e58f1538d34b6016d12  jboss-4.2.3.GA/client/wsdl4j.jar
ed5c09d33cf4c5890b6f6717218a61d8  jboss-4.2.3.GA/server/default/deploy/jboss-web.deployer/jasper-jdt.jar
ee115a042d2ae4baf09d90b9eb4b30f9  jboss-4.2.3.GA/server/all/deploy/jboss-bean.deployer/jboss-bean-deployer.jar
ee7817ae8aca64286e2b28de47a2cea6  jboss-4.2.3.GA/server/default/deploy/jbossws.sar/xmlsec.jar
eec5acb554b0acda16a0628393678ffa  jboss-4.2.3.GA/client/FastInfoset.jar
efbabd683eef45f8856f0b9810ab1939  jboss-4.2.3.GA/server/default/lib/commons-httpclient.jar
efdb93b5d64b77abe11a95be4647464d  jboss-4.2.3.GA/server/minimal/lib/log4j.jar
f04dd155e5699a94c7799f551c16e06d  jboss-4.2.3.GA/server/default/deploy/jboss-aop-jdk50.deployer/pluggable-instrumentor.jar
f0a26436f56e29df9d2df9fcadb9ff67  jboss-4.2.3.GA/client/jbosssx-client.jar
f105e1886c02c10453600ff5946083b8  jboss-4.2.3.GA/server/default/deploy/jbossws.sar/jaxb-api.jar
f2277ff863d89d8caf52d78c6d2f2857  jboss-4.2.3.GA/client/jboss-jaxws-ext.jar
f2cb21547527429ac88fb80c66382f78  jboss-4.2.3.GA/client/javassist.jar
f3141ca9fee1a6aab70f597e2a9466dc  jboss-4.2.3.GA/client/wstx.jar
f3bd0382c9dead309979407b5e9c81d2  jboss-4.2.3.GA/client/jboss-remoting.jar
f4dba3baf0d4073c4eefb3832bd21938  jboss-4.2.3.GA/lib/jboss-system.jar
f5758982cb54ca342864ba4126a63228  jboss-4.2.3.GA/client/xmlsec.jar
f58a2b9ac11bbbf7a29145577cea0bcb  jboss-4.2.3.GA/server/all/deploy/management/console-mgr.sar/jcommon.jar
f5ee97cb520c3cf2af4df9c316317196  jboss-4.2.3.GA/server/default/deploy/jboss-web.deployer/jsf-libs/jboss-faces.jar
f61339bcfeb37287c1941421ebc2c54d  jboss-4.2.3.GA/server/all/lib/jbossmq.jar
f67f355c3d82b67a9228f79fa1a475cd  jboss-4.2.3.GA/server/default/deploy/ejb3.deployer/jboss-ejb3.jar
f69fa1e6490663cd86d49454e9186eb5  jboss-4.2.3.GA/server/default/lib/jbossws-framework.jar
f6ded295201f37cad70dff6e320e35fd  jboss-4.2.3.GA/server/all/lib/jboss-jsr88.jar
f9d92def798129c87c21e796bd1d8104  jboss-4.2.3.GA/client/hibernate-client.jar
fa36b60de7f27743abe3a3b70261b2ae  jboss-4.2.3.GA/server/all/lib/jboss-common-jdbc-wrapper.jar
faec8e7eeaa8e36b7147cd162363c208  jboss-4.2.3.GA/client/jboss-ejb3-client.jar
fb0bb955ae8e7e61bde9937d719b2e61  jboss-4.2.3.GA/server/default/lib/activation.jar
fb1b754e59ab66f737ea9edeae5d8e9a  jboss-4.2.3.GA/client/jboss-jaxws.jar
fc4da59df88a0ad7a869b34a3bcb1f8b  jboss-4.2.3.GA/server/all/deploy/jbossws.sar/stax-api.jar
fde2108aee06e323c9513d1581efccb4  jboss-4.2.3.GA/server/all/lib/jboss-saaj.jar
fde299fc3317e6fe9fe840952bd90da0  jboss-4.2.3.GA/server/all/lib/jboss-serialization.jar
fe5ab885a1fc740c163f7310789eecf4  jboss-4.2.3.GA/server/all/lib/antlr.jar
fef5fa5c4028b90f33dfb170f7ab3040  jboss-4.2.3.GA/server/default/deploy/jboss-aop-jdk50.deployer/jrockit-pluggable-instrumentor.jar
