#!/usr/bin/perl

use File::Path;
use File::Find;
use File::Basename;
use Getopt::Long qw(:config no_auto_abbrev);

sub print_help {
print<<End_of_Help;
###########################################################################
*USAGE: checkoutReOrgMacarthur.pl

    Example: 
    
    It will checkout the source after re-org.

Supported Options:
  -help(-h) : print THIS help 

End_of_Help
}

sub execute {
    my $cmd = shift;
    print "$0 is executing: $cmd\n";
    my $retval = system($cmd);
    if ($retval)
    {
        print "[EXE-warning]: The command [$cmd] is not finished normally\n";
    }
    $retval;
}

sub update_subs {

    if ( -d ) {

        if ( $File::Find::name =~ /\/\.svn/ ) {

            # don't work on subversion related directories
            return;
        }
        ## if ( $File::Find::name =~ /flash_environment/ ) {
        ##     return;
        ## }

        # for other directories, do the following
        ## print "$File::Find::name\n";
        $cnt = 5;
        while ($cnt && execute qq[svn update --force $coVer $File::Find::name])
        {
            print "Previous svn-update failed; retry svn-update once more\n";
            --$cnt;
        }
        return;
    }
} 

 my $mail_list_for_make_err      = qq[griffinhuang\@realtek.com.tw edward.chen\@realtek.com.tw fptsai\@realtek.com.tw goodallstar\@realtek.com.tw korsenchang\@realtek.com.tw bonds.lu\@realtek.com.tw elainechang\@realtek.com.tw ycchang7\@realtek.com.tw ];
#my $mail_list_for_make_err      = qq[griffinhuang\@realtek.com.tw edward.chen\@realtek.com.tw fptsai\@realtek.com.tw];
#my $mail_list_for_make_err      = qq[griffinhuang\@realtek.com.tw                             fptsai\@realtek.com.tw goodallstar\@realtek.com.tw];
#my $mail_list_for_make_err      = qq[                                                                                    fptsai\@realtek.com.tw];

my $help                        = 0;
                                
my $debug                       = 0;
my $svnRootTime                 = "";
my $svnRootVer                  = -1;
my $apVer                       = -1;
my $CreateCodeBase              = 1;
my $RootDir                     = "svn";
my $CheckoutOpenSource          = 0;
my $DoMake                      = 0;
my $DoMakeOpenSource            = 0;
my $MakeBranchsrcSingle         = 1;
my @project                     = ();
my $SubProject                  = "";
my $common                      = "macarthur";
my $SvnSystemURL                = "";
my $SendMakeErrorMail           = 0;
my $UserScript                  = "";
my $UseSvnSwitch                = 0;

################################################################################################################################################################
# Get options from command line.
################################################################################################################################################################
%optl=("help"                        => \$help,
       "h"                           => \$help,
       "debug!"                      => \$debug,
       "svnRootTime=s"               => \$svnRootTime,
       "svnRootVer=n"                => \$svnRootVer,
       "apVer=n"                     => \$apVer,
       "CreateCodeBase!"             => \$CreateCodeBase,
       "RootDir=s"                   => \$RootDir,
       "CheckoutOpenSource!"         => \$CheckoutOpenSource,
       "DoMake!"                     => \$DoMake,
       "DoMakeOpenSource!"           => \$DoMakeOpenSource,
       "MakeBranchsrcSingle!"        => \$MakeBranchsrcSingle,
       "project=s"                   => \@project,
       "common=s"                    => \$common,
       "SvnSystemURL=s"              => \$SvnSystemURL,
       "SendMakeErrorMail!"          => \$SendMakeErrorMail,
       "UserScript=s"                => \$UserScript,
       "UseSvnSwitch!"               => \$UseSvnSwitch,
       );
       
if (!GetOptions(%optl))
{
    exit;
}

if (0 == $#project+1)
{
    @project[0] = "Hisense";
}
@project = split (/,/,join(',',@project));

if( $help ){
    &print_help;
    exit;
}

$ENV{'SHELL'} = "/bin/bash";
$ENV{'PATH'} = "/usr/local/bin:$ENV{'PATH'}";

$ENV{'LC_CTYPE'} = "en_US.UTF-8";
#LANG=zh_TW.Big5
#LC_ALL=zh_TW.Big5
#export LC_ALL
#export LANG


chomp ($scriptDir = `pwd`);
$scriptBasename = basename($scriptDir); # should represent a time such as 201203141500.
print "scriptBasename: $scriptBasename\n";


eval { # catch all "die"


if ( $debug )
{
    printf "please check ....";
    my $dummy= "";
    chomp ($dummy = <STDIN>);
}

if ( -1 == $svnRootVer )
{
    my $svnRootTime_with_prefix = "";
    if ("" ne $svnRootTime)
    {
        $svnRootTime_with_prefix = qq[-r $svnRootTime];
    }
    chomp ($svnRootVer          = `svn list $svnRootTime_with_prefix --verbose http://172.21.0.100/svn/col/DVR | grep "\\.\\/" | cut -d " " -f2`);
    if (!($svnRootVer =~ /[0-9]+/)) 
    {
        print "illegal value! svnRootVer: $svnRootVer";
        die   "illegal value! svnRootVer: $svnRootVer";
    }
}
print "svnRootVer: $svnRootVer\n";
print "common: $common\n";
print "project: @project\n";

if ( -1 == $apVer )
{
    $apVer = $svnRootVer;
}

if ( "" eq $SvnSystemURL)
{
    $SvnSystemURL               = q[http://172.21.0.100/svn/col/DVR/branches/software];
}

$coVer = qq[-r $apVer]; 

chomp ($curTime = `date +%Y%m%d%H%M`);

if ($CreateCodeBase)    
{
    
    if (-e "$scriptDir/$RootDir")
    {
        execute qq[mv $scriptDir/$RootDir $scriptDir/${RootDir}_backup_at_$curTime];
    }
    
 
    chdir  qq[$scriptDir];
   #execute qq[svn checkout $coVer http://172.21.0.100/svn/col/DVR/branches/software_tv_reorg_tmp svn];
    execute qq[svn checkout $coVer -N $SvnSystemURL $scriptDir/$RootDir];
    if ( "macarthur" eq lc($common) ) 
    {
        if ($UseSvnSwitch)
        {
            execute qq[svn update   $coVer                  $scriptDir/$RootDir/common_macarthur];
            execute qq[svn switch $coVer http://172.21.0.100/svn/col/DVR/darwin/software/common_mac  $scriptDir/$RootDir/common_macarthur];
        }
        else
        {
            execute qq[svn co $coVer http://172.21.0.100/svn/col/DVR/darwin/software/common_mac  $scriptDir/$RootDir/common_macarthur];
        }
    }
    else
    {
        if ($UseSvnSwitch)
        {
            execute qq[svn update   $coVer                  $scriptDir/$RootDir/common_$common];
            execute qq[svn switch $coVer http://172.21.0.100/svn/col/DVR/$common/software/common $scriptDir/$RootDir/common_$common];
        }
        else
        {
            execute qq[svn co $coVer http://172.21.0.100/svn/col/DVR/$common/software/common $scriptDir/$RootDir/common_$common];
        }
    } 
    execute qq[svn update   $coVer -N               $scriptDir/$RootDir/system];
    execute qq[svn update   $coVer                  $scriptDir/$RootDir/system/src];
    execute qq[svn update   $coVer                  $scriptDir/$RootDir/system/include];
    execute qq[svn update   $coVer                  $scriptDir/$RootDir/system/lib];
    execute qq[svn update   $coVer                  $scriptDir/$RootDir/system/lib_release];
    execute qq[svn update   $coVer -N               $scriptDir/$RootDir/system/project];
    execute qq[svn update   $coVer                  $scriptDir/$RootDir/system/project/WatchDogApp];
    if ( $CheckoutOpenSource ) {  execute qq[svn update   $coVer                  $scriptDir/$RootDir/system/open_source]; }
    
    foreach $prj (@project)
    {
        execute qq[svn update   $coVer                  $scriptDir/$RootDir/system/project/$prj];
    }
    
    if ( "" ne $UserScript )
    {
        execute qq[sh $UserScript $scriptDir/$RootDir];
    }

    chdir  qq[$scriptDir/$RootDir];

    #to do default config change here
    
    if ( "generic" eq lc(@project[0]) ) # CONFIG_50, Generic
    {
        execute qq[sed -i "s/^QUICK_CONFIG =/QUICK_CONFIG = CONFIG_50\\n#QUICK_CONFIG =/"   $scriptDir/$RootDir/system/include/MakeConfig];
        execute qq[sed -i "s/^QUICK_SUB_CONFIG =/QUICK_SUB_CONFIG =\\n#QUICK_SUB_CONFIG =/" $scriptDir/$RootDir/system/include/MakeConfig];
    }
    elsif ( "hisense" eq lc(@project[0]) ) # CONFIG_60/CONFIG_60_1, Hisense 
    {
        execute qq[sed -i "s/^QUICK_CONFIG =/QUICK_CONFIG = CONFIG_60\\n#QUICK_CONFIG =/"   $scriptDir/$RootDir/system/include/MakeConfig];
        execute qq[sed -i "s/^QUICK_SUB_CONFIG =/QUICK_SUB_CONFIG = CONFIG_60_1\\n#QUICK_SUB_CONFIG =/" $scriptDir/$RootDir/system/include/MakeConfig];
    }

    ## ===========================================================================================================================================================================================================================================================
    ## ==== start to build === start to build === start to build === start to build === start to build === start to build === start to build === start to build === start to build === start to build === start to build === start to build === start to build === 
    ## ===========================================================================================================================================================================================================================================================

    if ($DoMake)
    {
        execute qq[make install_toolchain -C $scriptDir/$RootDir/system/src];
        execute qq[make ic_path           -C $scriptDir/$RootDir/system/src];

        # make system/open_source
        if ($CheckoutOpenSource && $DoMakeOpenSource) 
        {
            execute qq[make -C $scriptDir/$RootDir/system/open_source/c-ares];         
            execute qq[make -C $scriptDir/$RootDir/system/open_source/curl];           
            execute qq[make -C $scriptDir/$RootDir/system/open_source/database];       
            execute qq[make -C $scriptDir/$RootDir/system/open_source/ipodDB];         
            execute qq[make -C $scriptDir/$RootDir/system/open_source/mp3info];        
            execute qq[make -C $scriptDir/$RootDir/system/open_source/qDecoder];       
            execute qq[make -C $scriptDir/$RootDir/system/open_source/samba];          
            execute qq[make -C $scriptDir/$RootDir/system/open_source/sqlite];         
            execute qq[make -C $scriptDir/$RootDir/system/open_source/openssl];        
            execute qq[make -C $scriptDir/$RootDir/system/open_source/upnp];           
            execute qq[make -C $scriptDir/$RootDir/system/open_source/wpa_supplicant]; 
            execute qq[make -C $scriptDir/$RootDir/system/open_source/HTTPC];          
            execute qq[make -C $scriptDir/$RootDir/system/open_source/http_file];      
            execute qq[make -C $scriptDir/$RootDir/system/open_source/tinyxml];        
            execute qq[make -C $scriptDir/$RootDir/system/open_source/zlib-1.2.3];     
            execute qq[make -C $scriptDir/$RootDir/system/open_source/Libpng];         
            execute qq[make -C $scriptDir/$RootDir/system/open_source/font];           
            execute qq[make -C $scriptDir/$RootDir/system/open_source/miniupnpc];      
            execute qq[make -C $scriptDir/$RootDir/system/open_source/live];           
            execute qq[make -C $scriptDir/$RootDir/system/open_source/FastJpegLib];    
            execute qq[make -C $scriptDir/$RootDir/system/open_source/json-rpc];       
            execute qq[make -C $scriptDir/$RootDir/system/open_source/openssl_0.9.7m]; 
            execute qq[make -C $scriptDir/$RootDir/system/open_source/openssl_0.9.8u]; 
            execute qq[make -C $scriptDir/$RootDir/system/open_source/OpenCVlib];      
            execute qq[make -C $scriptDir/$RootDir/system/open_source/libutf8];        
            execute qq[make -C $scriptDir/$RootDir/system/open_source/icu];            
            execute qq[make -C $scriptDir/$RootDir/system/open_source/expat];          
            execute qq[make -C $scriptDir/$RootDir/system/open_source/gif];            
        }

        if ($MakeBranchsrcSingle)
        {
            execute qq[make -C $scriptDir/$RootDir/system/src];
        }

        foreach $prj (@project)
        {
            execute qq[make all release -C $scriptDir/$RootDir/system/project/$prj];
        }
    }

} # end of if ($CreateCodeBase)

1; # We must add this to avoid entering the following do {}

}  # end of eval
or do {
##     chomp ($errMsg = qq[die-signal caught: $q, $@]);
##     chomp ($timeGot = `date +%Y%m%d%H%M`);
## 
##     $DieError  = qq[dieerror_$timeGot.log];
## 
##     execute qq[echo "$errMsg" > $scriptDir/$DieError];
##     chdir  qq[$scriptDir];
##     execute qq[zip $DieError.zip $DieError];
## 
##     if ($SendMakeErrorMail)
##     {
##         execute qq[uuencode $scriptDir/$DieError.zip            $DieError.zip            | mail -s "error(s) during script-running. ($scriptDir)"             $mail_list_for_make_err];
##     }
};
print "the script finishes its job! ^^\n";

