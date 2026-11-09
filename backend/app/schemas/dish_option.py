"""Schema dữ liệu tùy chọn món ăn."""
from decimal import Decimal

from pydantic import BaseModel, ConfigDict, Field


class DishOptionBase(BaseModel):
    dish_id: int = Field(gt=0)
    group_name: str = Field(min_length=1, max_length=100)
    name: str = Field(min_length=1, max_length=100)
    price_extra: Decimal = Field(default=0, ge=0)
    is_required: bool = False


class DishOptionCreate(DishOptionBase):
    pass


class DishOptionUpdate(BaseModel):
    dish_id: int | None = Field(default=None, gt=0)
    group_name: str | None = Field(default=None, min_length=1, max_length=100)
    name: str | None = Field(default=None, min_length=1, max_length=100)
    price_extra: Decimal | None = Field(default=None, ge=0)
    is_required: bool | None = None


class DishOptionOut(DishOptionBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
