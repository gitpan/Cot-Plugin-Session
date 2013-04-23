package Cot::Plugin::Session;
use strict;
use warnings;
use 5.008005;
our $VERSION = "0.01";
use parent qw(Cot::Plugin);
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

sub bakecookie {
    my ( $self, %param ) = @_;
    $self->{_app}->res->cookies->{$SESSIONID} = {
        value => $self->{_sessid},
        %param,
    };
}

sub _load {
    my $self = shift;
    return if $self->{_sess};
    $self->{_sess}   = {};
    $self->{_sessid} = $self->{_app}->req->cookies->{$SESSIONID};
    $self->{_sessid} = Digest::SHA1::sha1_hex( rand() . $$ . {} . time )
      unless ( $self->{_sessid} && -f $self->_path );
    my $path = $self->_path;
    $self->{_sess} = YAML::LoadFile($path)
      if ( -f $path );
    $self->{_sess} ||= {};
}

sub _path {
    my $self = shift;
    sprintf( "%s/%s", $self->{_dir}, $self->{_sessid} );
}

sub get {
    my ( $self, $k ) = @_;
    $self->_load;
    $self->{_sess}->{$k};
}

sub set {
    my ( $self, $k, $v ) = @_;
    $self->_load;
    $self->{_sess}->{$k} = $v;
    YAML::DumpFile( $self->_path, $self->{_sess} );
}

sub delete {
    my $self = shift;
    $self->_load;
    $self->{_sess} = {};
    unlink $self->_path or croak $!;
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
        my $id = $self->session->get('id');
        $self->session->set('id', 'yshibata') unless $id;
        $self->session->bakecookie(path => '/',
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
        my $id = $self->session->get('id');
        #code
    };

=head2 set

Store value with key to session object.

    $self->session->set('id', 'yshibata');

=head2 delete

Delete session object.

    $self->session->delete;

=head2 bakecookie

Bake session id COOKIE to HTTP header.

    $self->session->bakecookie(path => '/',
                               expires => time + 24 * 60 * 60,
                               domain => '.example.com',);

=head1 LICENSE

Copyright (C) Yusuke Shibata

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Yusuke Shibata E<lt>shibata@yusukeshibata.jpE<gt>

