using DG.Tweening;
using System;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UniRx;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using Zenject;

public class Gimmick_Goal : MonoBehaviour
{
    [SerializeField] Image Span;
    [SerializeField] TextMeshProUGUI Text;
    [SerializeField] TextMeshProUGUI NextText;
    [SerializeField] TextMeshProUGUI retrayText;

    [Inject]
    SceneAdaptor Adaptor;

    private void Awake()
    {
        Observable.EveryUpdate()
                  .Where(x => Input.GetKeyDown(KeyCode.Return))
                  .Subscribe(x => Reload(gameObject.scene.name));

        Observable.EveryUpdate()
                  .Where(x => Input.GetKeyDown(KeyCode.Space))
                  .Subscribe(x => Load("StageSelect"));
    }

    async void Reload(string name)
    {
        await Adaptor.ReLoad(name);
    }

    async void Load(string name)
    {
        await Adaptor.SceneLoadAsync(name);
    }

    void OnCollisionEnter(Collision other)
    {
        other.transform.GetComponent<Rigidbody>().isKinematic = true;


        DOTween.Sequence()
               .Append(Span.DOFade(0.8f, 0.5f))
               .Append(Text.transform.DOScaleX(1, 0.3f))
               .Append(DOTween.To(() => Text.characterSpacing, (x) => Text.characterSpacing = x, 40, 2))
               .Append(NextText.DOFade(1, 0.5f))
               .Append(retrayText.DOFade(1, 0.5f));

    }
}
