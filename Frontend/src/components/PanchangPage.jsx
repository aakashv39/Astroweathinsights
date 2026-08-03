import React, { useEffect, useMemo, useState } from 'react';
import { Icon } from '@iconify/react';
import { getActivityMuhurat, getPanchangSnapshot } from '../services/api';

const formatDateTimeLocal = (date = new Date()) => {
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  const hours = String(date.getHours()).padStart(2, '0');
  const minutes = String(date.getMinutes()).padStart(2, '0');
  return `${year}-${month}-${day}T${hours}:${minutes}`;
};

const timezoneOffsetHours = () => {
  return -(new Date().getTimezoneOffset() / 60);
};

const formatReadableDateTime = (value) => {
  if (!value) return 'Not available';
  const parsed = new Date(value);
  if (Number.isNaN(parsed.getTime())) {
    return value;
  }
  return new Intl.DateTimeFormat('en-IN', {
    dateStyle: 'medium',
    timeStyle: 'short',
    hour12: true,
  }).format(parsed);
};

const PanchangPage = () => {
  const [form, setForm] = useState({
    place: 'Varanasi',
    latitude: '25.3176',
    longitude: '82.9739',
    datetime_local: formatDateTimeLocal(),
    timezone_offset_hours: String(timezoneOffsetHours()),
    mode: 'exact_time',
  });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [result, setResult] = useState(null);
  const [useToday, setUseToday] = useState(true);
  const [activeTab, setActiveTab] = useState('panchang');

  const [muhuratForm, setMuhuratForm] = useState({
    activity: 'general',
    strict_mode: true,
  });
  const [muhuratLoading, setMuhuratLoading] = useState(false);
  const [muhuratError, setMuhuratError] = useState('');
  const [muhuratResult, setMuhuratResult] = useState(null);

  const onChange = (e) => {
    const { name, value } = e.target;
    setForm((prev) => ({ ...prev, [name]: value }));
  };

  const fetchPanchang = async ({ useCurrentTime = false } = {}) => {
    setLoading(true);
    setError('');
    try {
      const payload = {
        place: form.place,
        latitude: form.latitude ? Number(form.latitude) : null,
        longitude: form.longitude ? Number(form.longitude) : null,
        datetime_local: useCurrentTime ? formatDateTimeLocal() : form.datetime_local,
        timezone_offset_hours: form.timezone_offset_hours
          ? Number(form.timezone_offset_hours)
          : null,
        mode: form.mode,
      };
      const data = await getPanchangSnapshot(payload);
      setResult(data);
    } catch (err) {
      setError(err.message || 'Unable to fetch Panchang data.');
    } finally {
      setLoading(false);
    }
  };

  const submit = async (e) => {
    e.preventDefault();
    if (activeTab === 'panchang') {
      await fetchPanchang({ useCurrentTime: useToday });
      return;
    }
    await fetchMuhurat({ useCurrentTime: useToday });
  };

  useEffect(() => {
    fetchPanchang({ useCurrentTime: true });
  }, []);

  const handleUseTodayToggle = (enabled) => {
    setUseToday(enabled);
    if (enabled) {
      const currentDateTime = formatDateTimeLocal();
      setForm((prev) => ({ ...prev, datetime_local: currentDateTime }));
    }
  };

  const fetchMuhurat = async ({ useCurrentTime = false } = {}) => {
    setMuhuratLoading(true);
    setMuhuratError('');
    try {
      const payload = {
        place: form.place,
        latitude: form.latitude ? Number(form.latitude) : null,
        longitude: form.longitude ? Number(form.longitude) : null,
        datetime_local: useCurrentTime ? formatDateTimeLocal() : form.datetime_local,
        timezone_offset_hours: form.timezone_offset_hours
          ? Number(form.timezone_offset_hours)
          : null,
        activity: muhuratForm.activity,
        mode: form.mode,
        strict_mode: Boolean(muhuratForm.strict_mode),
      };
      const data = await getActivityMuhurat(payload);
      setMuhuratResult(data);
    } catch (err) {
      setMuhuratError(err.message || 'Unable to fetch Muhurat guidance.');
    } finally {
      setMuhuratLoading(false);
    }
  };

  const onMuhuratFieldChange = (e) => {
    const { name, value, type, checked } = e.target;
    setMuhuratForm((prev) => ({
      ...prev,
      [name]: type === 'checkbox' ? checked : value,
    }));
  };

  const cards = useMemo(() => {
    if (!result) return [];
    return [
      { label: 'Tithi', value: result.tithi_name, sub: `#${result.tithi_1_30} • ${result.paksha}` },
      { label: 'Vara', value: result.vara_name, sub: `#${result.vara_1_7}` },
      { label: 'Nakshatra', value: result.nakshatra_name, sub: `#${result.nakshatra_1_27}` },
      { label: 'Yoga', value: result.yoga_name, sub: `#${result.yoga_1_27}` },
      { label: 'Karana', value: result.karana_name, sub: `#${result.karana_1_11}` },
      { label: 'Solar Month', value: result.hindu_solar_month, sub: result.sankranti_day ? 'Sankranti Day' : 'Regular Day' },
    ];
  }, [result]);

  const muhuratVerdictStyles = useMemo(() => {
    const verdict = muhuratResult?.verdict;
    if (verdict === 'allow') {
      return 'bg-emerald-100 text-emerald-800 border-emerald-200';
    }
    if (verdict === 'caution') {
      return 'bg-amber-100 text-amber-800 border-amber-200';
    }
    return 'bg-red-100 text-red-800 border-red-200';
  }, [muhuratResult]);

  return (
    <section className="min-h-screen pt-28 pb-16 px-6 md:px-12 lg:px-20 bg-[radial-gradient(circle_at_20%_20%,rgba(251,191,36,0.20),transparent_45%),radial-gradient(circle_at_80%_20%,rgba(245,158,11,0.15),transparent_35%),linear-gradient(180deg,#fffef9_0%,#fff7e8_100%)]">
      <div className="max-w-7xl mx-auto">
        <div className="rounded-3xl border border-amber-100 bg-white/85 backdrop-blur-md shadow-xl shadow-amber-100/40 overflow-hidden">
          <div className="px-6 md:px-8 py-8 md:py-10 border-b border-amber-100 bg-gradient-to-r from-amber-50 to-yellow-50">
            <div className="flex items-center gap-2 text-amber-700 text-xs font-bold uppercase tracking-[0.2em] mb-3">
              <Icon icon="ph:sun-fill" />
              <span>Panchang</span>
            </div>
            <h1 className="text-3xl md:text-5xl font-serif font-black text-slate-900 leading-tight mb-4">
              Daily Panchang with
              <span className="text-transparent bg-clip-text bg-gradient-to-r from-amber-500 to-amber-700"> AstroTechWealth</span>
            </h1>
            <p className="text-slate-600 max-w-3xl text-base md:text-lg">
              Check Tithi, Vara, Nakshatra, Yoga, and Karana for any location and datetime using the HowisthedayPanchang engine.
            </p>

            <div className="mt-5 inline-flex rounded-xl bg-white border border-amber-200 p-1 gap-1">
              <button
                type="button"
                onClick={() => setActiveTab('panchang')}
                className={`px-4 py-2 rounded-lg text-sm font-bold transition-all ${activeTab === 'panchang'
                  ? 'bg-gradient-to-r from-amber-500 to-amber-700 text-white shadow'
                  : 'text-slate-600 hover:bg-amber-50'
                  }`}
              >
                Panchang
              </button>
              <button
                type="button"
                onClick={() => setActiveTab('muhurat')}
                className={`px-4 py-2 rounded-lg text-sm font-bold transition-all ${activeTab === 'muhurat'
                  ? 'bg-gradient-to-r from-amber-500 to-amber-700 text-white shadow'
                  : 'text-slate-600 hover:bg-amber-50'
                  }`}
              >
                Find Correct Muhurat
              </button>
            </div>
          </div>

          <div className="grid grid-cols-1 lg:grid-cols-5 gap-0">
            <div className="lg:col-span-2 p-6 md:p-8 border-r-0 lg:border-r border-amber-100">
              <h2 className="text-xl font-serif font-bold text-slate-900 mb-5">
                {activeTab === 'panchang' ? 'Panchang Input' : 'Muhurat Input'}
              </h2>
              <form onSubmit={submit} className="space-y-4">
                <div className="rounded-xl bg-amber-50 border border-amber-200 p-3">
                  <p className="m-0 text-xs font-bold uppercase tracking-widest text-amber-700 mb-2">Date Selection</p>
                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-2">
                    <button
                      type="button"
                      onClick={() => handleUseTodayToggle(true)}
                      className={`rounded-lg px-3 py-2 text-sm font-bold transition-all ${useToday
                        ? 'bg-gradient-to-r from-amber-500 to-amber-700 text-white shadow-md shadow-amber-300/40'
                        : 'bg-white text-slate-700 border border-slate-200 hover:bg-slate-50'
                        }`}
                    >
                      Today's Panchang
                    </button>
                    <button
                      type="button"
                      onClick={() => handleUseTodayToggle(false)}
                      className={`rounded-lg px-3 py-2 text-sm font-bold transition-all ${!useToday
                        ? 'bg-gradient-to-r from-amber-500 to-amber-700 text-white shadow-md shadow-amber-300/40'
                        : 'bg-white text-slate-700 border border-slate-200 hover:bg-slate-50'
                        }`}
                    >
                      Choose Other Day
                    </button>
                  </div>
                </div>

                <div>
                  <label className="block text-xs font-bold uppercase tracking-widest text-slate-500 mb-1.5">Place</label>
                  <input
                    name="place"
                    value={form.place}
                    onChange={onChange}
                    className="w-full border border-slate-200 rounded-xl px-4 py-2.5 focus:outline-none focus:ring-2 focus:ring-amber-500"
                    placeholder="Varanasi"
                    required
                  />
                </div>

                <div className="grid grid-cols-2 gap-3">
                  <div>
                    <label className="block text-xs font-bold uppercase tracking-widest text-slate-500 mb-1.5">Latitude</label>
                    <input
                      name="latitude"
                      value={form.latitude}
                      onChange={onChange}
                      className="w-full border border-slate-200 rounded-xl px-4 py-2.5 focus:outline-none focus:ring-2 focus:ring-amber-500"
                      placeholder="25.3176"
                    />
                  </div>
                  <div>
                    <label className="block text-xs font-bold uppercase tracking-widest text-slate-500 mb-1.5">Longitude</label>
                    <input
                      name="longitude"
                      value={form.longitude}
                      onChange={onChange}
                      className="w-full border border-slate-200 rounded-xl px-4 py-2.5 focus:outline-none focus:ring-2 focus:ring-amber-500"
                      placeholder="82.9739"
                    />
                  </div>
                </div>

                {activeTab === 'muhurat' && (
                  <div className="rounded-xl bg-slate-50 border border-slate-200 p-3 space-y-3">
                    <div>
                      <label className="block text-xs font-bold uppercase tracking-widest text-slate-500 mb-1.5">Activity</label>
                      <select
                        name="activity"
                        value={muhuratForm.activity}
                        onChange={onMuhuratFieldChange}
                        className="w-full border border-slate-200 rounded-xl px-4 py-2.5 focus:outline-none focus:ring-2 focus:ring-amber-500"
                      >
                        <option value="general">general</option>
                        <option value="marriage">marriage</option>
                        <option value="education">education</option>
                        <option value="travel">travel</option>
                        <option value="business">business</option>
                        <option value="new_job">new_job</option>
                      </select>
                    </div>
                    <label className="flex items-center gap-2 text-sm font-semibold text-slate-700">
                      <input
                        type="checkbox"
                        name="strict_mode"
                        checked={muhuratForm.strict_mode}
                        onChange={onMuhuratFieldChange}
                        className="accent-amber-600"
                      />
                      Strict Mode
                    </label>
                  </div>
                )}

                {!useToday && (
                  <div>
                    <label className="block text-xs font-bold uppercase tracking-widest text-slate-500 mb-1.5">Date & Time (Local)</label>
                    <input
                      type="datetime-local"
                      name="datetime_local"
                      value={form.datetime_local}
                      onChange={onChange}
                      className="w-full border border-slate-200 rounded-xl px-4 py-2.5 focus:outline-none focus:ring-2 focus:ring-amber-500"
                      required
                    />
                  </div>
                )}

                <div className="grid grid-cols-2 gap-3">
                  <div>
                    <label className="block text-xs font-bold uppercase tracking-widest text-slate-500 mb-1.5">Timezone Offset</label>
                    <input
                      name="timezone_offset_hours"
                      value={form.timezone_offset_hours}
                      onChange={onChange}
                      className="w-full border border-slate-200 rounded-xl px-4 py-2.5 focus:outline-none focus:ring-2 focus:ring-amber-500"
                      placeholder="5.5"
                    />
                  </div>
                  <div>
                    <label className="block text-xs font-bold uppercase tracking-widest text-slate-500 mb-1.5">Mode</label>
                    <select
                      name="mode"
                      value={form.mode}
                      onChange={onChange}
                      className="w-full border border-slate-200 rounded-xl px-4 py-2.5 focus:outline-none focus:ring-2 focus:ring-amber-500"
                    >
                      <option value="exact_time">exact_time</option>
                      <option value="sunrise_tithi">sunrise_tithi</option>
                    </select>
                  </div>
                </div>

                <button
                  type="submit"
                  disabled={activeTab === 'panchang' ? loading : muhuratLoading}
                  className="w-full bg-gradient-to-r from-amber-500 to-amber-700 text-white font-bold py-3 rounded-xl shadow-lg shadow-amber-300/40 hover:brightness-105 transition-all disabled:opacity-60"
                >
                  {activeTab === 'panchang'
                    ? (loading ? 'Calculating Panchang...' : (useToday ? "Refresh Today's Panchang" : 'Get Panchang'))
                    : (muhuratLoading ? 'Finding Muhurat...' : 'Find Correct Muhurat')}
                </button>
              </form>

              {activeTab === 'panchang' && error && (
                <div className="mt-4 p-3 rounded-xl bg-red-50 border border-red-200 text-sm text-red-700">
                  {error}
                </div>
              )}

              {activeTab === 'muhurat' && muhuratError && (
                <div className="mt-4 p-3 rounded-xl bg-red-50 border border-red-200 text-sm text-red-700">
                  {muhuratError}
                </div>
              )}
            </div>

            <div className="lg:col-span-3 p-6 md:p-8">
              <h2 className="text-xl font-serif font-bold text-slate-900 mb-5">
                {activeTab === 'panchang' ? 'Panchang Snapshot' : 'Muhurat Result'}
              </h2>

              {activeTab === 'panchang' && !result && (
                <div className="rounded-2xl border border-dashed border-amber-200 bg-amber-50/50 p-8 text-center text-slate-500">
                  Loading Panchang details...
                </div>
              )}

              {activeTab === 'panchang' && !!result && (
                <>
                  <div className="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-3 gap-3 mb-5">
                    {cards.map((card) => (
                      <div key={card.label} className="rounded-2xl border border-amber-100 bg-white p-4">
                        <p className="text-[11px] uppercase tracking-widest text-slate-500 font-bold mb-1">{card.label}</p>
                        <p className="text-xl font-black text-slate-900 mb-0.5">{card.value}</p>
                        <p className="text-xs text-slate-500 m-0">{card.sub}</p>
                      </div>
                    ))}
                  </div>

                  <div className="rounded-2xl border border-slate-200 bg-slate-50 px-4 py-4 text-sm text-slate-700 space-y-2">
                    <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-1">
                      <span className="font-semibold">Sunrise</span>
                      <span>{formatReadableDateTime(result.sunrise_local)}</span>
                    </div>
                    <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-1">
                      <span className="font-semibold">Sunset</span>
                      <span>{formatReadableDateTime(result.sunset_local)}</span>
                    </div>
                    <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-1">
                      <span className="font-semibold">Source Time Used</span>
                      <span>{formatReadableDateTime(result.source_datetime_used)}</span>
                    </div>
                    <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-1">
                      <span className="font-semibold">Location Used</span>
                      <span>
                        {result.place || form.place}
                        {result.latitude && result.longitude ? ` (${result.latitude}, ${result.longitude})` : ''}
                      </span>
                    </div>
                  </div>

                  {Array.isArray(result.notes) && result.notes.length > 0 && (
                    <div className="mt-4 rounded-2xl border border-amber-200 bg-amber-50 px-4 py-3">
                      <p className="text-xs font-bold uppercase tracking-widest text-amber-700 mb-1">Notes</p>
                      <ul className="text-sm text-amber-800 list-disc pl-5 m-0">
                        {result.notes.map((note, idx) => (
                          <li key={`${note}-${idx}`}>{note}</li>
                        ))}
                      </ul>
                    </div>
                  )}
                </>
              )}

              {activeTab === 'muhurat' && !muhuratResult && (
                <div className="rounded-2xl border border-dashed border-amber-200 bg-amber-50/50 p-8 text-center text-slate-500">
                  Submit the form to find correct Muhurat.
                </div>
              )}

              {activeTab === 'muhurat' && !!muhuratResult && (
                <>
                  <div className="flex flex-wrap items-center gap-3 mb-4">
                    <span className={`px-3 py-1.5 rounded-full border text-xs font-bold uppercase tracking-wider ${muhuratVerdictStyles}`}>
                      Verdict: {muhuratResult.verdict}
                    </span>
                    <span className="px-3 py-1.5 rounded-full border border-slate-200 text-xs font-bold uppercase tracking-wider text-slate-700 bg-white">
                      Score: {muhuratResult.score}
                    </span>
                    <span className="px-3 py-1.5 rounded-full border border-slate-200 text-xs font-bold uppercase tracking-wider text-slate-700 bg-white">
                      Activity: {muhuratResult.activity}
                    </span>
                  </div>

                  <div className="rounded-2xl border border-slate-200 bg-slate-50 p-4 mb-4">
                    <p className="m-0 text-sm text-slate-700 font-semibold">
                      {muhuratResult.explanation?.summary || 'Muhurat evaluation summary is available.'}
                    </p>
                  </div>

                  <div className="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-3 mb-5">
                    {Object.entries(muhuratResult.factor_results || {}).map(([key, factor]) => (
                      <div key={key} className="rounded-2xl border border-amber-100 bg-white p-4">
                        <p className="text-[11px] uppercase tracking-widest text-slate-500 font-bold mb-1">{key}</p>
                        <p className="text-base font-black text-slate-900 mb-0.5">{factor.status}</p>
                        {factor.result?.verdict && (
                          <p className="text-xs text-slate-500 m-0">Verdict: {factor.result.verdict}</p>
                        )}
                      </div>
                    ))}
                  </div>

                  <div className="rounded-2xl border border-slate-200 bg-slate-50 px-4 py-4 text-sm text-slate-700 space-y-2 mb-4">
                    <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-1">
                      <span className="font-semibold">Sunrise</span>
                      <span>{formatReadableDateTime(muhuratResult.panchang?.sunrise_local)}</span>
                    </div>
                    <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-1">
                      <span className="font-semibold">Sunset</span>
                      <span>{formatReadableDateTime(muhuratResult.panchang?.sunset_local)}</span>
                    </div>
                    <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-1">
                      <span className="font-semibold">Tithi</span>
                      <span>{muhuratResult.panchang?.tithi_name} ({muhuratResult.panchang?.paksha})</span>
                    </div>
                    <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-1">
                      <span className="font-semibold">Location Used</span>
                      <span>
                        {muhuratResult.panchang?.place || form.place}
                        {muhuratResult.panchang?.latitude && muhuratResult.panchang?.longitude
                          ? ` (${muhuratResult.panchang.latitude}, ${muhuratResult.panchang.longitude})`
                          : ''}
                      </span>
                    </div>
                  </div>

                  {Array.isArray(muhuratResult.reason_ids) && muhuratResult.reason_ids.length > 0 && (
                    <div className="rounded-2xl border border-red-200 bg-red-50 px-4 py-3">
                      <p className="text-xs font-bold uppercase tracking-widest text-red-700 mb-1">Reason IDs</p>
                      <div className="flex flex-wrap gap-2">
                        {muhuratResult.reason_ids.map((reasonId) => (
                          <span key={reasonId} className="px-2.5 py-1 rounded-full text-xs font-bold bg-white text-red-700 border border-red-200">
                            {reasonId}
                          </span>
                        ))}
                      </div>
                    </div>
                  )}
                </>
              )}
            </div>
          </div>
        </div>
      </div>
    </section>
  );
};

export default PanchangPage;