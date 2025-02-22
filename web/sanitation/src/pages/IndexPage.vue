<template>
  <div class="heading">
    <div>РАЗДЕЛ IV.</div>
    <div>ОБЪЕКТЫ СОРТИРОВКИ И ПЕРЕРАБОТКИ ТВЕРДЫХ КОММУНАЛЬНЫХ ОТХОДОВ. 2025</div>
  </div>

  <div class="row">
    <q-select
      class="col"
      label="Организация"
      :options="organizations"
      :option-label="(x) => x.name"
      :option-value="(x) => x.id"
      v-model="selectedOrganization"
      map-options
      emit-value
    ></q-select>
    <q-select
      class="col"
      label="Область"
      :options="regions"
      :option-label="(x) => x.name"
      :option-value="(x) => x.id"
      v-model="selectedRegion"
      map-options
      emit-value
    ></q-select>
    <q-select
      class="col"
      label="Район"
      :options="districts"
      :option-label="(x) => x.name"
      :option-value="(x) => x.id"
      v-model="selectedDistrict"
      map-options
      emit-value
    ></q-select>
  </div>
  <!-- Table -->
  <table class="row" style="border: 1px solid; border-collapse: collapse">
    <tbody>
      <tr>
        <th class="cell">Наименование показателя</th>
        <th class="cell">Номер строки</th>
        <th class="cell">Количество объектов, ед.</th>
        <th class="cell">Установленная мощность, тыс. т в год</th>
        <th class="cell">Пропущено твердых коммунальных отходов (сумма граф 4 и 5), тыс. т</th>
        <th class="cell">Отобрано вторичных материальных ресурсов, тыс. т</th>
        <th class="cell">Отправлено отходов на захоронение, тыс. т</th>
      </tr>
      <tr v-for="row in rows" :key="row.name">
        <td class="cell">{{ row.name }}</td>
        <td class="cell text-center">{{ row.number }}</td>
        <td class="cell" v-for="value in row.values" :key="value.toString()">
          <q-input v-model="data[value]" class="text-center"></q-input>
        </td>
      </tr>
    </tbody>
  </table>
  <q-btn @click="addFulfiment">Сохранить</q-btn>
</template>

<script setup>
import { ref, onMounted, watch } from 'Vue'
import { api } from '../boot/axios'
import { useQuasar } from 'quasar'
const data = ref([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])

const $q = useQuasar()
const organizations = ref([])
const regions = ref([])
const districts = ref([])

const selectedOrganization = ref()
const selectedRegion = ref()
const selectedDistrict = ref()

const range = (start, end) => {
  let array = []
  for (let i = 0; start < end; i++) {
    array[i] = start
    start++
  }
  return array
}

const rows = ref([
  {
    name: 'Сортировочно-перегрузочные станции и линии сортировки (досортировки) отходов, всего',
    number: 40,
    values: range(0, 5),
  },
  {
    name: '- из них введено в эксплуатацию в отчетном году',
    number: 41,
    values: range(5, 10),
  },
  {
    name: 'Заводы по переработке ТКО, всего',
    number: 42,
    values: range(10, 15),
  },
  {
    name: '- из них введено в эксплуатацию в отчетном году',
    number: 43,
    values: range(15, 20),
  },
])

const getDictionary = async (type) => {
  let responce = await api.get('/api/Values/GetDictitonary?type=' + type)
  return responce.data
}

const addFulfiment = async () => {
  if (selectedOrganization.value && selectedRegion.value && selectedDistrict.value) {
    let body = {
      id: 0,
      values: data.value,
      year: 2025,
      sourceId: selectedOrganization.value,
      regionId: selectedRegion.value,
      districtId: selectedDistrict.value,
    }
    await api.post('/api/Values/AddFulfilment', body)
    $q.notify('Сохранено!')
  } else {
    $q.notify('Необходимо выбрать все параметры')
  }
}

const getLastFulfiment = async () => {
  let responce = await api.get('/api/Values/GetPreviousFulfilment', {
    params: {
      sourceId: selectedOrganization.value,
      regionId: selectedRegion.value,
      districtId: selectedDistrict.value,
      year: 2025,
    },
  })
  return responce.data
}

onMounted(async () => {
  organizations.value = await getDictionary(1)
  regions.value = await getDictionary(2)
  districts.value = await getDictionary(3)
})

watch([selectedOrganization, selectedRegion, selectedDistrict], async () => {
  if (selectedOrganization.value && selectedRegion.value && selectedDistrict.value) {
    let responce = await getLastFulfiment()
    if (!responce.values) {
      data.value = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    } else {
      data.value = responce.values
    }
  }
})
</script>
<style>
.cell {
  vertical-align: top;
  border: 1px solid;
  padding: 5px;
}
</style>
