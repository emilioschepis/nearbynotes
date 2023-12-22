create policy "authenticated users can upload images"
on storage.objects
for insert
to authenticated
with check (bucket_id = 'images' and (storage.foldername(name))[1] = auth.uid()::text);
