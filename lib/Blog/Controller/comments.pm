package Blog::Controller::comments;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Blog::Controller::comments - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched Blog::Controller::comments in comments.');
}
sub comment_save :Local :Args(0) {
    my ($self, $c) = @_;
    my $body = $c->request->params->{body} || 'N/A';
    my $post_id=$c->request->params->{post_id};
    # Create the user
    my $comment = $c->model('DB::Comment')->create({
    body => $body,
    auther_id=>$c->user( )->id,
    post_id=>$post_id
    });
    # Store new model object in stash and set template
    #$c->stash(user => $user,template => 'users/show.tt');
    #$c->response->redirect('id'.{$user.id}.'show');
#    $c->stash(user=>$user,template=>'users/show.tt');
    my $myid = $post_id;
    $c->response->redirect("/pid/$myid/show");
}
sub intr :Chained('/') :PathPart('cid') :CaptureArgs(1){
    my ($self, $c, $id) = @_;
    $c->stash(rec=>$c->model('DB::Comment')->find($id));

}
sub delete_comment :Chained('intr') :PathPart('delete') :Args(0) {
 my ($self, $c) = @_;
 my $myid = $c->stash->{rec}->post_id;
 $c->stash->{rec}->delete;
# c->forward('list');

 $c->response->redirect("/pid/$myid/show");

}
sub edit_comment :Chained('intr') :PathPart('edit_comment') :Args(0) {
 my ($self, $c) = @_;
 $c->stash(template => 'comments/edit_view.tt');
}
sub do_update :Chained('intr') :PathPart('edit') :Args(0) {
 my ($self, $c) = @_;
 my $body = $c->request->params->{body};
    my $myid = $c->stash->{rec}->post_id;
    $c->stash->{rec}->update( {body=>$body } );

  #$c->forward('list');
   $c->response->redirect("/pid/$myid/show");


}



=encoding utf8

=head1 AUTHOR

ramy,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
