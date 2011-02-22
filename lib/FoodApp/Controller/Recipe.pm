package FoodApp::Controller::Recipe;
use Moose;
use namespace::autoclean;
use Data::Dumper;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

FoodApp::Controller::Recipe - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched FoodApp::Controller::Recipe in Recipe.');
}


=head2 form_create

Reperisce i dati da un form per creare una nuova ricetta.

=cut

sub form_create :Local {
	my ( $self, $c ) = @_;
	
	$c->stash->{'template'} = 'recipes/form_create.tt';
	
	if ($c->user_exists() && $c->check_user_roles('admin')) {
		if (lc $c->req->method eq 'post') {
			my $params = $c->req->params;
			
			$c->log->debug($params->{numProd});
			
			# Creo la ricetta
			my $recipe = $c->model('FoodAppDB::Recipe')->create({
				description	=> $params->{description},
				preparation	=> $params->{preparation},
			});
			
			# Variabile che contiene il numero di prodotti inseriti
			my $numprod = $params->{numProd};
			
			my $i;
			my @products = ();
			my $prod;
			
			for ($i = 0; $i < $numprod; $i++) {
				my $name = "product".$i;
				if (! ($prod = $c->model('FoodAppDB::Product')->find( 
				{ name => $params->{$name} } ))) {
					$c->stash->{'message'} = "Uno dei prodotti inseriti non è 
					presente nel catalogo.";
				}
				else {
					push @products, $prod;
				}
			}
			#$c->log->debug(Dumper(@products));
			
			foreach my $p (@products) {
				$p->uses->create( { recipe_id => $recipe->id } );
			}
			
			# Redirigo l'utente alla lista di ricette
			if ($recipe) {
				$c->res->redirect($c->uri_for(
					$c->controller('Recipe')->action_for('list')));
			}
			
		}
		
	}
}

=head2 base

Azione che permette di inserire nello stash i dati relativi alle ricette consentendo di visualizzare una lista.

=cut

sub base :Chained('/') :PathPart('recipe') :CaptureArgs(0) {
	my ($self, $c) = @_;
	
	$c->stash(recipes_rs => $c->model('FoodAppDB::Recipe'));
}


=head2 list

Azione che consente di visualizzare una lista delle ricette presenti nel database.

=cut

sub list :Chained('base') :PathPart('list') :Args(0) {
	my ($self, $c) = @_;
	
	if ( $c->user_exists() ) {
		$c->stash(template => 'recipes/list.tt');
	}
	else {
		return $c->res->redirect( $c->uri_for(
			$c->controller('People')->action_for('login'),
			{status_msg => "Solo effettuando il login potrai visualizzare questo contenuto."} ) );
	}
}

sub recipe : Chained('base'): PathPart(''): CaptureArgs(1) {
	my ($self, $c, $recipeid) = @_;
	if ($recipeid =~ /\D/) {
		die "Errore nell'URL, recipeid non contiene solo cifre!";
	}
	
	my $recipe = $c->stash->{recipes_rs}->find({ id => $recipeid},
										   { key => 'primary'});
										   
	die "Ricetta non presente" if(!$recipe);
	
	$c->stash(recipe => $recipe);
}

sub show_recipe : Chained('recipe') :PathPart('show_recipe') :Args(0) {
	my ($self, $c) = @_;

	$c->stash->{'template'} = 'recipes/show_recipe.tt';

	if (! $c->user_exists()) {
		return $c->res->redirect( $c->uri_for( 
			$c->controller('people')->action_for('login'),
			{status_msg => "Devi avere eseguito il login per visualizzare questo contenuto."} ) );
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
