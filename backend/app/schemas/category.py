"""Schema dữ liệu danh mục."""
from pydantic import BaseModel, ConfigDict, Field


class CategoryBase(BaseModel):
    name: str = Field(min_length=1, max_length=100)
    sort_order: int = Field(default=0, ge=0)
    is_active: bool = True


class CategoryCreate(CategoryBase):
    pass


class CategoryUpdate(BaseModel):
    name: str | None = Field(default=None, min_length=1, max_length=100)
    sort_order: int | None = Field(default=None, ge=0)
    is_active: bool | None = None


class CategoryOut(CategoryBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
