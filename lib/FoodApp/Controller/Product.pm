package FoodApp::Controller::Product;
use Moose;
use namespace::autoclean;
use Handel::Currency;
use Data::Currency;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

FoodApp::Controller::Product - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched FoodApp::Controller::Product in Product.');
}

=head2 list

Routine che permette di visualizzare i record presenti nella tabella 'prodotti' del 
database

=cut

sub list :Local {
	my ( $self, $c ) = @_;

	# Ricava tutti i record dei prodotti come oggetti modello di prodotto e li
	# salva nello stash dove essi possono essere acceduti dal template TT
	$c->stash(products => [$c->model('FoodAppDB::Product')-> all]);
	
	## Controllo che l'utente sia loggato, altrimenti gli impedisco di 
	## visualizzare la lista dei cibi
	if ( $c->user_exists() ) {
		# Setta il template TT da usare.
		# Mostro all'utente la lista dei cibi 
		$c->stash(template => 'products/list.tt');
	}
	else {
		## Se l'utente non è loggato, lo redirigo alla pagina di login
		$c->stash->{'message'} = 'Per visualizzare questo contenuto devi essere loggato';
		$c->detach('/people/login');
		
	}
}

=head2 form_create

Reperisce i dati da un form che permette di creare un nuovo prodotto.

=cut

sub form_create :Local {
	my ($self, $c) = @_;
	
	$c->stash->{'template'} = 'products/form_create.tt';
	
	if ($c->user_exists() && $c->check_user_roles('admin')) {
		if ((lc $c->req->method eq 'post') && ($c->req->param('Submit'))) {
			my $params = $c->req->params;
			
			#Data::Currency->code('EUR');
			#Data::Currency->format('FMT_STANDARD');
			my $val_price = $params->{price};
			if ($val_price =~ m/\,/) {
				$val_price =~ s/\,/\./;
			}
			
			my $price = Handel::Currency->new($val_price, 'EUR', 'FMT_STANDARD');
			
			$c->form(
				name => [qw/NOT_BLANK/],
				description => [qw/NOT_BLANK/],
				price => [qw/NOT_BLANK/],
				duration => [qw/NOT_BLANK/]
			);
		
			my $result = $c->form;
			if ( $result->has_error ) {
				return $c->res->redirect( $c->uri_for(
					$c->controller('Product')->action_for('form_create'),
					{status_msg => "I campi da inserire non possono essere lasciati vuoti."} ) );
			}
						
			# Creo il prodotto
			my $product = $c->model('FoodAppDB::Product')->create({
				name		=> $params->{name},
				description => $params->{description},
				#price		=> $params->{price},
				price		=> $price,
				duration	=> $params->{duration},
			});
		
			# Salvo il modello del nuovo oggetto nello stash e setto il template
			$c->stash(
				product => $product,
				template => 'products/create_done.tt'
			);
		}
	}
	else {
		$c->res->redirect($c->uri_for(
			$c->controller('Product')->action_for('list'),
			{status_msg => 'Non hai i privilegi per creare un cibo' }) );
	}
}

=head2 base

Azione che serve per inserire nello stash un prodotto che sarà necessario per effettuare operazioni su di esso.

=cut

sub base :Chained('/') :PathPart('product') :CaptureArgs(0) {
	my ($self, $c) = @_;
	
	# Salva il ResultSet nello stash in modo che sia disponibile per altri
	# metodi.
	$c->stash(products_rs => $c->model('FoodAppDB::Product'));
	
}

=head2 object

Serve per memorizzare nello stash un prodotto dato il suo id in modo che sia possibile successivamente cancellare tale prodotto.

=cut

sub object :Chained('base') :PathPart('id') :CaptureArgs(1) {
	# $id = chiave primaria del cibo da cancellare
	my ($self, $c, $id) = @_;
	
	# Trova l'oggetto food e lo memorizza nello stash
	$c->stash(object => $c->stash->{products_rs}->find($id));
	
	# Assicura che la ricerca ha dato esiti positivi.
	die "Product $id not found!" if !$c->stash->{object};
	
}

=head2 delete

=cut

sub delete :Chained('object') :PathPart('delete') :Args(0) {
	my ($self, $c) = @_;
	
	## Usa l'oggetto food trovato da object e lo cancella
	$c->stash->{object}->delete;
	$c->response->redirect($c->uri_for($self->action_for('list'),
		{status_msg => "Prodotto Cancellato."}) );
}

=head1 AUTHOR

enrico,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
