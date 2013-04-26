package Cot::Plugin::Session;
use strict;
use warnings;
use 5.008005;
our $VERSION = "0.05";
use parent qw(Cot::Plugin);
use File::Spec;
use Digest::SHA1 ();
use YAML         ();
use Carp;
our $SESSIONID = 'sessid';

sub init {
    my ( $self, $cot ) = @_;
    $self->{_app} = $cot;
    $self->{_dir} = $ENV{TMPDIR} || '/tmp';
    $cot->session($self);
}

sub load {
    my $self   = shift;
    my $sessid = $self->{_app}->req->cookies->{$SESSIONID};
    $sessid = Digest::SHA1::sha1_hex( rand() . $$ . {} . time )
      unless ( $sessid && -f $self->_path($sessid) );
    my $path    = $self->_path($sessid);
    my $sessobj = {};
    $sessobj = YAML::LoadFile($path) if ( -f $path );
    new Cot::Plugin::Session::Object(
        {
            _app => $self->{_app},
            path => $path,
            obj  => $sessobj,
            id   => $sessid,
        }
    );
}

sub _path {
    my ( $self, $sessid ) = @_;
    File::Spec->catfile( $self->{_dir}, $sessid );
}

package Cot::Plugin::Session::Object;

sub new {
    my ( $class, $obj ) = @_;
    bless $obj, $class;
}

sub get {
    my ( $self, $k ) = @_;
    $self->{obj}->{$k};
}

sub set {
    my ( $self, $k, $v ) = @_;
    $self->{obj}->{$k} = $v;
    YAML::DumpFile( $self->{path}, $self->{obj} );
}

sub delete {
    my $self = shift;
    unlink $self->{path} if ( -f $self->{path} );
}

sub bakecookie {
    my ( $self, %param ) = @_;
    $self->{_app}->res->cookies->{$Cot::Plugin::Session::SESSIONID} = {
        value => $self->{id},
        %param,
    };
}

1;
__END__

=encoding utf-8

=head1 NAME

Cot::Plugin::Session - Cot framework Simple session plugin.

=head1 SYNOPSIS

    use Cot;
    use Cot::Plugin qw/Session/;

    get '/sign/in' => sub {
        my $self = shift;
        my $sess = $self->session->load;
        my $id = $sess->get('id');
        $sess->set('id', 'yshibata') unless $id;
        $sess->bakecookie(path => '/',
                          expires => time + 24 * 60 * 60,);
        #code
    };

=head1 DESCRIPTION

Cot::Plugin::Session is Cot framework Simple session plugin.
using $cot->B<session> namespace.
Session file stored to $ENV{TMPDIR} or /tmp as a YAML file.

=head1 FUNCTIONS

=head2 get

Retrieve value with key from session object.

    use Cot;
    use Cot::Plugin qw/Session/;

    get '/sign/in' => sub {
        my $self = shift;
        my $sess = $self->session->load;
        my $id = $sess->get('id');
        #code
    };

=head2 set

Store value with key to session object.

    my $sess = $self->session->load;
    $sess->set('id', 'yshibata');

=head2 delete

Delete session object.

    my $sess = $self->session->load;
    $sess->delete;

=head2 bakecookie

Bake session id COOKIE to HTTP header.

    my $sess = $self->session->load;
    $sess->bakecookie(path => '/',
                      expires => time + 24 * 60 * 60,
                      domain => '.example.com',);

=head1 LICENSE

Copyright (C) Yusuke Shibata

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Yusuke Shibata E<lt>shibata@yusukeshibata.jpE<gt>

