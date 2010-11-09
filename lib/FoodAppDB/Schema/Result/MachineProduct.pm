package FoodAppDB::Schema::Result::MachineProduct;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

FoodAppDB::Schema::Result::MachineProduct

=cut

__PACKAGE__->table("machine_product");

=head1 ACCESSORS

=head2 machine_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 batch_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "machine_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "batch_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("machine_id", "batch_id");

=head1 RELATIONS

=head2 batch

Type: belongs_to

Related object: L<FoodAppDB::Schema::Result::ProductBatch>

=cut

__PACKAGE__->belongs_to(
  "batch",
  "FoodAppDB::Schema::Result::ProductBatch",
  { id => "batch_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 machine

Type: belongs_to

Related object: L<FoodAppDB::Schema::Result::Machine>

=cut

__PACKAGE__->belongs_to(
  "machine",
  "FoodAppDB::Schema::Result::Machine",
  { id => "machine_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2010-11-08 16:57:51
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:s3y7f0i4o4eIZk9d+jQbAg


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
