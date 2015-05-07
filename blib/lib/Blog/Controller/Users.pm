package Blog::Controller::Users;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Blog::Controller::Users - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched Blog::Controller::Users in Users.');
}

sub list :Local :Args(0) {
my ($self, $c) = @_;
$c->stash(users => [$c->model('DB::User')->all()]);
$c->stash(template => 'users/list.tt');
}
#sub base :: chained('/') :PathPart('Users'){
#
#}
#sub newform ::chained('base') :PathPart('new'){
#    $c->stash(template => 'users/reg.tt');
#}
=encoding utf8

=head1 AUTHOR

ramy,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
