using UniRx;
using UnityEngine;
using Zenject;

namespace Chargezuma.View.Inputs
{

    /// <summary>
    /// Sceneに対する処理の際の入力窓口
    /// </summary>
    public class SceneToken : MonoBehaviour
    {
        //遷移したいシーン名
        [SerializeField] string NextSceneName;
        //遷移の制限
        [SerializeField] ChangeType Type;
        //Container内のAdaptorを取得
        [Inject]
        ISceneAdaptor Adaptor;
        //Collider内に存在するかのフラグ
        bool StayTrigger;

        public void Awake()
        {
            if (Type == ChangeType.InputValue)
            {
                Observable.EveryUpdate()
                      .Where(x => Input.GetKeyDown(KeyCode.Return))
                      .Subscribe(x => Adaptor.LoadScene(NextSceneName))
                      .AddTo(this);
            }
            else if (Type == ChangeType.ColliderInput)
            {
                Observable.EveryUpdate()
                          .Where(x => StayTrigger == true)
                          .Where(x => Input.GetKeyDown(KeyCode.Return))
                          .Subscribe(x => Adaptor.LoadScene(NextSceneName))
                          .AddTo(this);
            }

        }

        private void OnTriggerEnter(Collider other)
        {
            StayTrigger = true;

            if (Type == ChangeType.Collider)
            {
                Adaptor.LoadScene(NextSceneName);
            }
        }

        private void OnTriggerExit(Collider other)
        {
            StayTrigger = false;
        }

    }
}

/// <summary>
/// 遷移の制限の選択肢
/// InputValue : 値の入力で遷移
/// Collider : コライダーに入ったら遷移
/// InputCollider : コライダーに接触している状態で値を入力で遷移
/// </summary>
public enum ChangeType
{
    InputValue,
    Collider,
    ColliderInput
}

