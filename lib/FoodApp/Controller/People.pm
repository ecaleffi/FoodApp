package FoodApp::Controller::People;
use Moose;
use namespace::autoclean;
use Handel::Cart;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

FoodApp::Controller::People - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched FoodApp::Controller::People in People.');
}

=head2 login

Azione che permette agli utenti di loggarsi al sito

=cut

sub login :Local :Args(0) {
	my ( $self, $c ) = @_;

	$c->stash->{'template'} = 'people/login.tt';

	if ( exists($c->req->params->{'name'}) ) {
		if ($c->authenticate( {
			name => $c->req->params->{'name'},
			password => $c->req->params->{'password'}
		}) )
		{
			## l'utente ha eseguito il login
			$c->stash->{'message'} = "Hai effettuato il login con successo.";
			$c->response->redirect(
				$c->uri_for($c->controller('Product')->action_for(
'list') )
			);
			$c->detach();
			return;
		}
		
		else {
			$c->stash->{'message'} = "Login invalido.";
		}
	}
} 

=head2 logout

Azione che permette agli utenti di fare il logout.

=cut

sub logout :Local :Args(0) {
	my ( $self, $c ) = @_;
	$c->stash->{'template'} = 'people/logout.tt';
	$c->logout();
	my $cart = $c->model('Cart')->search({
		shopper => $c->session->{'shopper'},
	})->first;
	if ($cart) {
		$cart->destroy;
	}
	else {
		warn "Carrello non trovato";
	}
		
	$c->delete_session;
	$c->stash->{'message'} = "Hai eseguito il logout con successo.";
}

=head2 base

Azione che permette di inserire nello stash i dati relativi agli ustenti e ai relativi ruoli. Grazie a tale azione sarà poi possibile eseguire altre particolari azioni concatenate a questa.

=cut

sub base :Chained('/') :PathPart('people') :CaptureArgs(0) {
	my ($self, $c) = @_;
	
	$c->stash(users_rs => $c->model('FoodAppDB::User'));
	$c->stash(roles_rs => $c->model('FoodAppDB::Role'));
}

=head2 register

Azione che permette di registrare un nuovo utente nel database del sito.

=cut

sub register :Chained('base') :PathPart('register') :Args(0) {
	my ($self, $c) = @_;
	
	$c->stash->{'template'} = 'people/register.tt';
	
	if (lc $c->req->method eq 'post') {
		# Ricavo i parametri inseriti nel form
		my $params = $c->req->params;
		
		## Ricavo il resultset degli utenti messi nello stash
		my $users_rs = $c->stash->{users_rs};
		
		$c->form(
			name => [qw/NOT_BLANK ASCII/],
			surname => [qw/NOT_BLANK ASCII/],
			password => [qw/NOT_BLANK/]
		);
		
		my $result = $c->form;
		if ( $result->has_error ) {
			return $c->res->redirect( $c->uri_for(
				$c->controller('People')->action_for('register'),
				{status_msg => "I campi contrassegnati non possono essere lasciati vuoti."} ) );
		}
		
		## Creo l'utente
		my $newuser = $users_rs->create({
			name			=> $params->{name},
			surname			=> $params->{surname},
			password		=> $params->{password},
			address			=> $params->{address},
			city			=> $params->{city},
			province_state	=> $params->{state},
			postal_code		=> $params->{post_code},
		});
		
		## Assegno il ruolo 'user' come defalut di ogni utente creato
		$newuser->have_right_to->create({ role_id => 2});
		
		## Autentico l'utente
		if ($c->authenticate({
			name 		=> $params->{name},
			password 	=> $params->{password} }) )
		{
		
		return $c->res->redirect( $c->uri_for(
			$c->controller('Product')->action_for('list'),
			{status_msg => "Utente creato con successo."} ) );
		}
		else {
			$c->stash->{'message'} = 'Errore nella creazione dell\'utente';
		}
	}
		
}

=head2 user

Cattura l'id di un utente che viene fornito tramite l'URL e inserisce l'utente trovato nello stash

=cut

sub user : Chained('base'): PathPart(''): CaptureArgs(1) {
	my ($self, $c, $userid) = @_;
	if ($userid =~ /\D/) {
		die "Errore nell'URL, userid non contiene solo cifre!";
	}
	
	my $user = $c->stash->{users_rs}->find({ id => $userid},
										   { key => 'primary'});
										   
	die "User non presente" if(!$user);
	
	$c->stash(user => $user);
}

=head2 profile

Consente di visualizzare il profilo di un utente

=cut

sub profile : Chained('user') :PathPart('profile') :Args(0) {
	my ($self, $c) = @_;
	
	if ($c->user_exists()) {
		my $user = $c->stash->{user};
		
		if (! $c->check_user_roles('admin')) {
			if ($user->id != $c->user->id ) {
				return $c->res->redirect( $c->uri_for(
				$c->controller('people')->action_for('profile'), 
				[$c->user->id],
				{status_msg => "Non puoi visualizzare il profilo di un altro utente."} ) );
			}
		}
	}
}

=head2 list

Azione che consente all'amministratore di visualizzare una lista di tutti gli utenti registrati al sito.

=cut

sub list :Chained('base') :PathPart('list') :Args(0) {
	my ($self, $c) = @_;
	
	if ($c->user_exists() && $c->check_user_roles('admin')) {
		$c->stash(template => 'people/list.tt')
	}
	else {
		return $c->res->redirect( $c->uri_for(
			$c->controller('Product')->action_for('list'),
			{status_msg => "Solo l'amministratore può visualizzare questo contenuto."} ) );
	}
}

=head2 delete

Azione che permette ad un utente di cancellarsi dal sito o all'amministratore di cancellare un utente.

=cut

sub delete :Chained('user') :PathPart('delete') :Args(0) {
	my ($slef, $c) = @_;
	
	if ($c->user_exists() && $c->check_user_roles('admin')) {
		my $user = $c->stash->{user};
		$user->delete();
	
	return $c->res->redirect( $c->uri_for(
		$c->controller('Product')->action_for('list'),
		{status_msg => "Utente cancellato."} ) );
	}
	
	if ($c->user_exists() && $c->check_user_roles('user')) {
		my $user = $c->stash->{user};
		if ($user->id == $c->user->id ) {
			$user->delete();
			
			$c->delete_session;
	
		return $c->res->redirect( $c->uri_for(
			$c->controller('people')->action_for('login'),
			{status_msg => "Utente cancellato. Per tornare nel sito devi registrarti nuovamente."} ) );
		}
		else {
			return $c->res->redirect( $c->uri_for(
			$c->controller('people')->action_for('profile'), 
			[$c->user->id],
			{status_msg => "Non puoi cancellare un altro utente."} ) );
		}
	}
	
}

=head1 AUTHOR

enrico,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
