CREATE TYPE notification_type AS ENUM (
    'vote_defi_collectif', 
    'nouveau_defi_collectif', 
    'streak_loss',
     'bilan',
     'nouvelle_action_communautaire');

CREATE TABLE public.notifications (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE,
    type notification_type NOT NULL,
    is_read boolean DEFAULT false,
    created_at timestamptz DEFAULT now(),
    
    data jsonb NOT NULL DEFAULT '{}'::jsonb 
);

