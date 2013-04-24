# NAME

Cot::Plugin::Session - Cot framework Simple session plugin.

# SYNOPSIS

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
        my $sess = $self->session->load;
        my $id = $sess->get('id');
        #code
    };

## set

Store value with key to session object.

    my $sess = $self->session->load;
    $sess->set('id', 'yshibata');

## delete

Delete session object.

    my $sess = $self->session->load;
    $sess->delete;

## bakecookie

Bake session id COOKIE to HTTP header.

    my $sess = $self->session->load;
    $sess->bakecookie(path => '/',
                      expires => time + 24 * 60 * 60,
                      domain => '.example.com',);

# LICENSE

Copyright (C) Yusuke Shibata

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Yusuke Shibata <shibata@yusukeshibata.jp>
