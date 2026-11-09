"""Model các lựa chọn của món ăn, ví dụ size và topping."""
from decimal import Decimal

from sqlalchemy import Boolean, ForeignKey, Numeric, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db.session import Base


class DishOption(Base):
    __tablename__ = "dish_options"

    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    dish_id: Mapped[int] = mapped_column(
        ForeignKey("dishes.id"), nullable=False
    )
    group_name: Mapped[str] = mapped_column(String(100), nullable=False)
    name: Mapped[str] = mapped_column(String(100), nullable=False)
    price_extra: Mapped[Decimal] = mapped_column(
        Numeric(12, 2), default=0, nullable=False
    )
    is_required: Mapped[bool] = mapped_column(Boolean, default=False, nullable=False)

    dish = relationship("Dish", back_populates="options")
