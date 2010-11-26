package FoodApp::Schema::Result::Use;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime", "EncodedColumn");

=head1 NAME

FoodApp::Schema::Result::Use

=cut

__PACKAGE__->table("uses");

=head1 ACCESSORS

=head2 recipe_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 product_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "recipe_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "product_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("recipe_id", "product_id");

=head1 RELATIONS

=head2 product

Type: belongs_to

Related object: L<FoodApp::Schema::Result::Product>

=cut

__PACKAGE__->belongs_to(
  "product",
  "FoodApp::Schema::Result::Product",
  { id => "product_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 recipe

Type: belongs_to

Related object: L<FoodApp::Schema::Result::Recipe>

=cut

__PACKAGE__->belongs_to(
  "recipe",
  "FoodApp::Schema::Result::Recipe",
  { id => "recipe_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2010-11-25 18:35:17
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:m0tAffV74s+i8zKTbHdwEg


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
