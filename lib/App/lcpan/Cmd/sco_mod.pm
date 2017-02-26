package App::lcpan::Cmd::sco_mod;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;
use Log::Any::IfLOG '$log';

require App::lcpan;

our %SPEC;

$SPEC{handle_cmd} = {
    v => 1.1,
    summary => 'Open module POD on search.cpan.org',
    description => <<'_',

This will open `http://search.cpan.org/perldoc?MODNAME`. `MODNAME` will first be
checked for existence in local index database.

_
    args => {
        %App::lcpan::common_args,
        %App::lcpan::mod_args,
    },
};
sub handle_cmd {
    my %args = @_;
    my $mod = $args{module};

    my $state = App::lcpan::_init(\%args, 'ro');
    my $dbh = $state->{dbh};

    my ($file_id) = $dbh->selectrow_array(
        "SELECT file_id FROM module WHERE name=?", {}, $mod);
    $file_id or return [404, "No such module '$mod'"];

    require Browser::Open;
    my $err = Browser::Open::open_browser("http://search.cpan.org/perldoc?$mod");
    return [500, "Can't open browser"] if $err;
    [200];
}

1;
# ABSTRACT:
