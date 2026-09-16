# Netdeck Turbo Demo

A Rails 8 network inventory demo focused on Hotwire navigation and reusable, server-rendered data tables.

## Presentation

The Marp-compatible slide deck at [`docs/turbo-presentation.md`](docs/turbo-presentation.md) explains the application's Turbo Drive, Frame, Stream, modal, toast, progressive-enhancement, and testing patterns with code from this repository.

## What it demonstrates

- **Turbo Drive navigation** for normal RESTful CRUD pages.
- **Turbo Frames** for independent filtering, sorting, and pagination with browser-history updates.
- **In-place editing** by replacing the `NetworkHost` frame on its show page.
- **On-demand modal editing** with a reusable native dialog, a RESTful nested resource, and targeted Turbo Stream updates.
- **Turbo toast notifications** rendered from redirect flashes or prepended by frame-only Turbo Stream responses.
- **Fizzy-style live refreshes** broadcast model changes to open inventory and detail pages, then morph only changed DOM while preserving scroll.
- **Bulk Turbo Stream updates** select multiple hosts, update their status atomically, and replace each affected table row with a temporary green highlight.
- **Edit-safe morphing** temporarily marks an active edit frame as permanent so an update from another browser cannot replace unsaved form input.
- **Stimulus enhancement** for debounced search, modal behavior, toast dismissal, morph-safe editing, and immediate select filters; core forms still work without JavaScript.
- **Reusable table building blocks**:
  - `Filterable` and `Sortable` whitelist query behavior at the model layer.
  - `TableScoped` keeps controllers thin and normalizes table parameters.
  - `TablePage` encapsulates pagination metadata without an external gem.
  - Shared filter and pagination partials plus a sortable-header helper can be reused by future resources.

The concern structure follows Fizzy's approach: shared traits live in `app/models/concerns`, while domain-specific traits such as addressing and refresh broadcasting live under `app/models/network_host` and are included by their short names from `NetworkHost`.

## Setup

```sh
bin/setup
bin/rails db:seed
bin/rails server
```

Open [http://localhost:3000](http://localhost:3000). The seed creates 40 hosts so pagination and filters are immediately visible.

## Tests

```sh
bin/rails test
```

## Adding the table behavior to another model

Include and configure the shared model concerns:

```ruby
class Circuit < ApplicationRecord
  include Filterable, Sortable

  filters_by :status, :provider
  searches_by :name, :circuit_id
  sorts_by :name, :status, :updated_at, default: :name
end
```

Then include `TableScoped` in its controller, call `table_for Circuit`, and render the shared `shared/tables/filters` and `shared/tables/pagination` partials inside a resource-specific Turbo Frame.
