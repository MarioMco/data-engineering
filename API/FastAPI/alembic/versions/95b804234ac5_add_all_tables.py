"""add all tables

Revision ID: 95b804234ac5
Revises: de23b06aab37
Create Date: 2022-12-03 17:48:12.399448

"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision = '95b804234ac5'
down_revision = 'de23b06aab37'
branch_labels = None
depends_on = None


def upgrade() -> None:
    # ### commands auto generated by Alembic - please adjust! ###
    op.create_table('employees',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('parent_id', sa.Integer(), nullable=True),
    sa.Column('first_name', sa.String(), nullable=False),
    sa.Column('last_name', sa.String(), nullable=False),
    sa.Column('middle_name', sa.String(), nullable=True),
    sa.Column('title', sa.String(), nullable=False),
    sa.Column('hire_date', sa.Date(), nullable=False),
    sa.Column('gender', sa.String(), nullable=False),
    sa.Column('email', sa.String(), nullable=False),
    sa.Column('created_at', sa.TIMESTAMP(timezone=True), server_default=sa.text('now()'), nullable=False),
    sa.PrimaryKeyConstraint('id'),
    sa.UniqueConstraint('email')
    )
    op.create_table('offers_list',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('offer_id', sa.Integer(), nullable=False),
    sa.Column('product_name', sa.String(), nullable=False),
    sa.Column('price', sa.Float(precision=10, decimal_return_scale=2), nullable=False),
    sa.Column('qty', sa.Integer(), nullable=False),
    sa.Column('amount', sa.Float(precision=10, decimal_return_scale=2), nullable=False),
    sa.Column('customer', sa.Integer(), nullable=False),
    sa.Column('created_at', sa.TIMESTAMP(timezone=True), server_default=sa.text('now()'), nullable=False),
    sa.Column('owner_id', sa.Integer(), nullable=False),
    sa.ForeignKeyConstraint(['owner_id'], ['users.id'], ondelete='CASCADE'),
    sa.PrimaryKeyConstraint('id')
    )
    # ### end Alembic commands ###


def downgrade() -> None:
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_table('offers_list')
    op.drop_table('employees')
    # ### end Alembic commands ###
