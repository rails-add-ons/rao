$(document).ready(function () {
  $('[data-auto-submit="true"]').each(function () {
    $(this).closest("form").append('<div class="loading">Loading&#8230;</div>');
    $(this).closest("form").submit();
  });
});