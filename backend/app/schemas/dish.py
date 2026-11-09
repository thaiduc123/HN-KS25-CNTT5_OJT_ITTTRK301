"""Schema dữ liệu món ăn."""
from decimal import Decimal

from pydantic import BaseModel, ConfigDict, Field


DISH_STATUSES = ("ĐANG BÁN", "HẾT MÓN", "ẨN")


class DishBase(BaseModel):
    category_id: int = Field(gt=0)
    name: str = Field(min_length=1, max_length=255)
    description: str | None = None
    price: Decimal = Field(default=0, ge=0)
    image: str | None = Field(default=None, max_length=500)
    status: str = Field(default="ĐANG BÁN", max_length=20)
    is_featured: bool = False


class DishCreate(DishBase):
    pass


class DishUpdate(BaseModel):
    category_id: int | None = Field(default=None, gt=0)
    name: str | None = Field(default=None, min_length=1, max_length=255)
    description: str | None = None
    price: Decimal | None = Field(default=None, ge=0)
    image: str | None = Field(default=None, max_length=500)
    status: str | None = Field(default=None, max_length=20)
    is_featured: bool | None = None


class DishOut(DishBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
