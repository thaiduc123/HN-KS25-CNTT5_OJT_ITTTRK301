from pydantic import BaseModel, ConfigDict, Field


class CategoryCreate(BaseModel):
    name: str = Field(min_length=1, max_length=100)
    sort_order: int = 0


class CategoryUpdate(BaseModel):
    name: str | None = Field(default=None, min_length=1, max_length=100)
    sort_order: int | None = None


class CategoryStatusUpdate(BaseModel):
    is_active: bool


class CategorySortItem(BaseModel):
    id: int
    sort_order: int


class CategoryReorder(BaseModel):
    categories: list[CategorySortItem]


class CategoryOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    name: str
    sort_order: int
    is_active: bool