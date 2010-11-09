package FoodApp::Schema::Result::ProductBatch;

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

FoodApp::Schema::Result::ProductBatch

=cut

__PACKAGE__->table("product_batch");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 order

Type: might_have

Related object: L<FoodApp::Schema::Result::Order>

=cut

__PACKAGE__->might_have(
  "order",
  "FoodApp::Schema::Result::Order",
  { "foreign.batch_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 machine_products

Type: has_many

Related object: L<FoodApp::Schema::Result::MachineProduct>

=cut

__PACKAGE__->has_many(
  "machine_products",
  "FoodApp::Schema::Result::MachineProduct",
  { "foreign.batch_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 contains

Type: has_many

Related object: L<FoodApp::Schema::Result::Contain>

=cut

__PACKAGE__->has_many(
  "contains",
  "FoodApp::Schema::Result::Contain",
  { "foreign.batch_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2010-10-29 11:26:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:YrzH/TdbW64f2OvZvyazUg

__PACKAGE__->many_to_many(machines => 'machine_products', 'machine');

# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
