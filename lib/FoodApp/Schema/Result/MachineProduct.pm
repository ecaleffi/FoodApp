package FoodApp::Schema::Result::MachineProduct;

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

FoodApp::Schema::Result::MachineProduct

=cut

__PACKAGE__->table("machine_product");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'char'
  is_nullable: 1
  size: 32

=head2 description

  data_type: 'text'
  is_nullable: 1

=head2 price

  data_type: 'money'
  is_nullable: 1

=head2 duration

  data_type: 'date'
  is_nullable: 1

=head2 qty

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "char", is_nullable => 1, size => 32 },
  "description",
  { data_type => "text", is_nullable => 1 },
  "price",
  { data_type => "money", is_nullable => 1 },
  "duration",
  { data_type => "date", is_nullable => 1 },
  "qty",
  { data_type => "integer", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 products_contained

Type: has_many

Related object: L<FoodApp::Schema::Result::ProductContained>

=cut

__PACKAGE__->has_many(
  "products_contained",
  "FoodApp::Schema::Result::ProductContained",
  { "foreign.product_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07006 @ 2011-02-16 10:48:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:cAEsU3lBP9YrWfZykJWGMg


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
