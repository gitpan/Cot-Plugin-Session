# NAME

Cot::Plugin::Session - Cot framework Simple session plugin.

# SYNOPSIS

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

# DESCRIPTION

Cot::Plugin::Session is Cot framework Simple session plugin.
using $cot->__session__ namespace.
Session file stored to $ENV{TMPDIR} or /tmp as a YAML file.

# FUNCTIONS

## get

Retrieve value with key from session object.

    use Cot;
    use Cot::Plugin qw/Session/;

    get '/sign/in' => sub {
        my $self = shift;
        my $id = $self->session->get('id');
        #code
    };

## set

Store value with key to session object.

    $self->session->set('id', 'yshibata');

## delete

Delete session object.

    $self->session->delete;

## bakecookie

Bake session id COOKIE to HTTP header.

    $self->session->bakecookie(path => '/',
                               expires => time + 24 * 60 * 60,
                               domain => '.example.com',);

# LICENSE

Copyright (C) Yusuke Shibata

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Yusuke Shibata <shibata@yusukeshibata.jp>
