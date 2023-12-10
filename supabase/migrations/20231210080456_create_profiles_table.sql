create table profiles (
  id uuid primary key references auth.users,
  created_at timestamp with time zone not null default now(),
  email text unique
);

alter table profiles enable row level security;

create policy "users can view their own profiles"
on public.profiles
for select
to authenticated
using (auth.uid() = id);

create function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id, created_at, email)
  values (new.id, new.created_at, new.email);
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

create view public_profiles as
  select profiles.id, profiles.created_at
  from profiles;
