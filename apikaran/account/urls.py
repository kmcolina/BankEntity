from django.urls import re_path

from apikaran.account.views import BasicAccountView

urlpatterns = [
    re_path('', BasicAccountView.as_view(), name="account"),
]
