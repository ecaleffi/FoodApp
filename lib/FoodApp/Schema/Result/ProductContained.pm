package FoodApp::Schema::Result::ProductContained;

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

FoodApp::Schema::Result::ProductContained

=cut

__PACKAGE__->table("product_contained");

=head1 ACCESSORS

=head2 machine_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 product_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "machine_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "product_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("machine_id", "product_id");

=head1 RELATIONS

=head2 product

Type: belongs_to

Related object: L<FoodApp::Schema::Result::MachineProduct>

=cut

__PACKAGE__->belongs_to(
  "product",
  "FoodApp::Schema::Result::MachineProduct",
  { id => "product_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 machine

Type: belongs_to

Related object: L<FoodApp::Schema::Result::Machine>

=cut

__PACKAGE__->belongs_to(
  "machine",
  "FoodApp::Schema::Result::Machine",
  { id => "machine_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07006 @ 2011-02-16 10:48:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ci4F/wRUpKspDL8dF131ew


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
